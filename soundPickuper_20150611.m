clear all;
%% 前処理
fname_withoutWAV = '141111_001';
music_fname = 'クロスロード.m4a';
filename = [fname_withoutWAV,'.wav'];
pass = [];
a_info = audioinfo(filename);
fs_input = a_info.SampleRate;
dur = a_info.Duration;

is_getaudio = 1;

%% 音楽データのテンポ推定
% [audio_music, fs_music] = audioread(music_fname);
% ma = miraudio(audio_music,fs_music);
% mtmp = mirtempo(ma);
% tempo = mirgetdata(mtmp);

%% フレームごとのパラメータ取得
deltaT = 1.0;   % フレーム分解能
shiftT = 0.5;   % フレームシフト長
fft_size = 2^15;% FFTサイズ
len_sec = 60;   % 音声ファイルを分割する時間長
paramtype = 1;

% 特徴ベクトル取得
[vec_time,vec_param] = ...
    getParameterVector(filename,deltaT,shiftT,fft_size,len_sec,paramtype);

%% 点数列作成
feedback = 10;
type_getscore = 1;
[~,vec_score] = calcScore(vec_time,vec_param,feedback,type_getscore);

%% 場面の分岐点検出
windowSize = 10;
dsrate = 10;
coeff_medfilt = 10;
filtertype = 1;
is_plot = 0;
[T_tmpscene,sf] = cutScene...
    (vec_time,vec_score,windowSize,coeff_medfilt,filtertype,dsrate,is_plot);
% 
% display([num2str(height(T_tmpscene)),' scenes returned cutScene']);

% T_tmpscene = splitScene(vec_time,2);

%% 類似場面の結合
wg_length = 60;
thr_dist = 1.5;
T_scene = sceneBind(vec_time,vec_param,T_tmpscene,thr_dist,wg_length);
display([num2str(height(T_scene)),' scenes returned sceneBind']);

viewScenes(vec_param,T_scene,length(vec_param(1,:)));
T_scene_minsec = time2min_sec(T_scene);

%% 切り出した場面ごとの点数計算

clear str_scene str_tmp

for i=1:height(T_scene)
    s_start = T_scene.scene_start(i);
    s_end   = T_scene.scene_end(i);
    %T_tmp = T_param((T_param.time>=s_start)&(T_param.time<=s_end),:);
    tv_tmp = vec_time((vec_time>=s_start)&(vec_time<=s_end));
    pv_tmp = vec_param((vec_time>=s_start)&(vec_time<=s_end),:);
    [str_scene(i).score,~] = calcScore(tv_tmp,pv_tmp,10,1);
    str_scene(i).time  = tv_tmp;
end

af = arrayfun(@(x) isempty(x.score), str_scene);

n = 1;
for i=1:length(af)
    if af(i)==0
        str_tmp(n) = str_scene(i);
        n=n+1;
    end
end
str_scene = str_tmp;

%% 切り出した場面ごとの素材部分をランダムに取り出す
num_pickup = 100;
sec_pickup = 60;    % in sec
sample_pickup = sec_pickup/shiftT;    % in sample

clear str_random str_tmp
str_random = randomPickup2(str_scene,num_pickup,sample_pickup);

af = arrayfun(@(x) height(x.table)==1, str_random);

n = 1;
for i=1:length(af)
    if af(i)==0
        str_tmp(n) = str_random(i);
        n=n+1;
    end
end
str_random = str_tmp;

%% オーディオ素材を音楽用サンプルに仕上げる
n = 0;
for i=1:length(str_random)
    if isempty(str_random(i).table) == 0
        n = n + 1;
    end
end

[audio_music,fs_music] = audioread(music_fname);
audio_music = audio_music(:,1);

ao_sec = 11;
fade_sec = 1;
amSampleLength = fs_music*(ao_sec-fade_sec);
aoSampleLength = fs_input*ao_sec;
num_parts = floor(length(audio_music)/amSampleLength);
audio_sample = zeros(num_parts,aoSampleLength);
is_plot = 0;

for i=1:num_parts
    if isempty(str_random(i).table) == 0
        display(['Scene ',num2str(i),' audio sample generating...']);
        a_tmp = audioread([fname_withoutWAV,'.wav'],...
            [fs_input*str_random(i).table.s_start(1)+1,...
            fs_input*str_random(i).table.s_end(1)]);
        a_tmp = a_tmp(:,1);
        index = (i-1)*amSampleLength;
        audio_sample(i,:) = audioSampleGenerator5...
            (audio_music((index+1):(index+aoSampleLength)),...
            fs_music,a_tmp,fs_input,ao_sec,0.2,0.8,1.2);
    else
        display(['Scene ',num2str(i),' audio sample generate skipped']);
    end
end

%% 音楽用サンプルを書き出す
fade_sec_rest = ao_sec - 2*fade_sec;
fade1 = linspace(0,1,fs_input*fade_sec);
fade2 = linspace(1,0,fs_input*fade_sec);
fade_rest = linspace(1,1,fs_input*fade_sec_rest);
fade = horzcat(fade1,fade_rest,fade2);
audio_out = zeros(1,num_parts*(fs_input*(ao_sec-fade_sec))+fs_input*fade_sec);
for i=1:num_parts
    st = (i-1)*fs_input*(ao_sec-fade_sec)+1;
    en = st + aoSampleLength-1;
    a_tmp = audio_sample(i,:).*fade;
    audio_out(st:en) = audio_out(st:en)+a_tmp;
end

audiowrite(['out','.wav'],audio_out,fs_input);
