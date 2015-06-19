clear all;
%% �O����
fname_withoutWAV = 'I:\VOICE\FOLDER05\141024_001';
music_fname = 'pop.00050.au';
filename = [fname_withoutWAV,'.wav'];
pass = [];
a_info = audioinfo(filename);
fs_input = a_info.SampleRate;
dur = a_info.Duration;

is_getaudio = 1;

%% ���y�f�[�^�̃e���|����
[audio_music, fs_music] = audioread(music_fname);
ma = miraudio(audio_music,fs_music);
mtmp = mirtempo(ma);
tempo = mirgetdata(mtmp);

%% �t���[�����Ƃ̃p�����[�^�擾
deltaT = 1.0;   % �t���[������\
shiftT = 0.5;   % �t���[���V�t�g��
fft_size = 2^15;% FFT�T�C�Y
len_sec = 60;   % �����t�@�C���𕪊����鎞�Ԓ�
paramtype = 1;

% �����x�N�g���擾
[vec_time,vec_param] = ...
    getParameterVector(filename,deltaT,shiftT,fft_size,len_sec,paramtype);

%% �_����쐬
feedback = 10;
type_getscore = 1;
[~,vec_score] = calcScore(vec_time,vec_param,feedback,type_getscore);

%% ��ʂ̕���_���o
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

%% �ގ���ʂ̌���
wg_length = 60;
thr_dist = 1.5;
T_scene = sceneBind(vec_time,vec_param,T_tmpscene,thr_dist,wg_length);
display([num2str(height(T_scene)),' scenes returned sceneBind']);

viewScenes(vec_param,T_scene,length(vec_param(1,:)));
T_scene_minsec = time2min_sec(T_scene);

%% �؂�o������ʂ��Ƃ̓_���v�Z

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

%% �؂�o������ʂ��Ƃ̑f�ޕ����������_���Ɏ��o��
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

%% �I�[�f�B�I�f�ނ����y�p�T���v���Ɏd�グ��
n = 0;
for i=1:length(str_random)
    if isempty(str_random(i).table) == 0
        n = n + 1;
    end
end

ao_sec = 10;
amSampleLength = fs_music*ao_sec;
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
            (audio_music((index+1):(index+amSampleLength)),...
            fs_music,a_tmp,fs_input,ao_sec,0.1,1.0,1.5);
    else
        display(['Scene ',num2str(i),' audio sample generate skipped']);
    end
end

%% ���y�p�T���v���������o��
num_samp = length(audio_sample(:,1));
len_samp = length(audio_sample(1,:));
outaudio = zeros(1,num_samp*len_samp);
for i=1:num_samp
    audiowrite(['out',num2str(i),'.wav'],audio_sample(i,:),fs_input);
end