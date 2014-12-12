clear all;
%% 前処理
fname_withoutWAV = '141121_001';
filename = [fname_withoutWAV,'.WAV'];
pass = ['\Users\Shunji\Music\RandomPickup\'];
a_info = audioinfo(filename);
fs = a_info.SampleRate;
dur = a_info.Duration;
i_stop = ceil(dur/60)-1;

is_getaudio = 1;

%% フレームごとのパラメータ取得
time = [];      % 時間
db = [];        % dB (P0=20*10^-6)
cent = [];      % スペクトル重心
deltaT = 1.0;   % フレーム分解能
shiftT = 0.5;   % フレームシフト長
fft_size = 2^15;% FFTサイズ
P0 = 2e-5;      % dB計算におけるP0

% パラメータ取得全体での計算時間の計測開始
t_total = cputime;
for i=0:i_stop
    % 1分ごとのパラメータ取得の計算時間の計測開始
    t_part = cputime;
    display(['calculating ',num2str(i),' to ',num2str(i+1)]);

    % 60秒ごとにパラメータ取得関数に入るが，末尾でオーバーしないようにする
    if (dur-i*60)<60
        interval = floor(dur)-i*60;
        s_start = i*60;
        s_end = s_start+interval;
    else
        s_start = i*60;
        s_end = (i+1)*60+shiftT;
    end
    
    % パラメータ取得し，一時変数に格納
    [t_time,t_db,t_cent] = soundPickuper_getparameter...
        (fname_withoutWAV,s_start,s_end,deltaT,shiftT,fft_size);
    
    % 一時変数を結合
    time = cat(1,time,t_time);
    db = cat(1,db,t_db);
    cent = cat(1,cent,t_cent);
    
    % 1分ごとのパラメータ取得の計算時間の計測終了
    t_part = cputime - t_part;
    display(['計算時間は ',num2str(t_part),' 秒です']);
end
% パラメータ取得全体での計算時間の計測終了
t_total = cputime - t_total;
display(['トータルの計算時間は ',num2str(t_total),' 秒です']);

clear t_time t_db t_cent t_part t_total s_start s_end;

%% 点数計算
deltaT_calcScore = 10;
type_getscore = 1;
[~,score] = calcScore4(time,db,cent,deltaT_calcScore,shiftT,type_getscore);

%%  テーブル作成
T_param = table(time,db,cent,score','VariableNames',...
    {'time','dB','cent','score'});

%% 場面の切り出し
windowSize = 31;
coeff_medfilt = 10;
[T_scene,sf,thsld_hi,thsld_low] = ...
    cutScene2(T_param.time,T_param.score,windowSize,coeff_medfilt,2,1,0);

% plot
plotScene(T_param,T_scene,sf,thsld_low,thsld_hi,windowSize);

%% 切り出した場面ごとの点数計算
for i=1:height(T_scene)
    s_start = T_scene.scene_start(i);
    s_end   = T_scene.scene_end(i);
    T_tmp = T_param((T_param.time>=s_start)&(T_param.time<=s_end),:);
    [str_scene(i).score,~] = ...
        calcScore3(T_tmp.time,T_tmp.dB,T_tmp.cent,deltaT_calcScore,shiftT);
    str_scene(i).time  = T_tmp.time';
end

%% 切り出した場面ごとの素材部分をランダムに取り出す
num_pickup = 100;
sec_pickup = 30;    % in sec
sample_pickup = sec_pickup/shiftT;    % in sample

str_random = randomPickup(str_scene,num_pickup,sample_pickup);

%% オーディオ素材を音楽用サンプルに仕上げる
tau = 0.05;
bpm = 85;
bars = 4;
beatperbar = 1;
noteunit = 4;
audio_sample = [];
for i=1:length(str_random)
    if isempty(str_random(i).table) == 0
        a_tmp = audioread([fname_withoutWAV,'.wav'],...
            [fs*str_random(i).table.s_start(1)+1,...
            fs*str_random(i).table.s_end(1)]);
        a_tmp = (a_tmp(:,1)+a_tmp(:,2))/2;
        audio_sample(i,:) = audioSampleGenerator...
            (a_tmp,fs,tau,bpm,bars,beatperbar,noteunit,0);
    end
end

%% 音楽用サンプルを書き出す
if is_getaudio == 1
    s = size(audio_sample);
    audio_all = [];
    for i=1:length(str_random)
        if isempty(str_random(i).table) == 0
            % s_tmp = floor(str_random(i).table.s_start(1));
            % e_tmp = floor(str_random(i).table.s_end(1));
            wfname = [pass,'scene',num2str(i),'.wav'];
            % '_time',num2str(s_tmp),'-',num2str(e_tmp),'.wav'];
            audiowrite(wfname,audio_sample(i,:),fs);
            
            audio_all = cat(2,audio_all,audio_sample(i,:));
        end
    end
    wfname = [pass,'scene_all','.wav'];
    audiowrite(wfname,audio_all,fs);
end

