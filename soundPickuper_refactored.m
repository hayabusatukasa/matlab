clear all;
%% �O����
fname_withoutWAV = '141226_001';
filename = [fname_withoutWAV,'.wav'];
pass = [];
a_info = audioinfo(filename);
fs = a_info.SampleRate;
dur = a_info.Duration;

is_getaudio = 1;

%% �t���[�����Ƃ̃p�����[�^�擾
deltaT = 1.0;   % �t���[������\
shiftT = 0.5;   % �t���[���V�t�g��
fft_size = 2^15;% FFT�T�C�Y
len_sec = 60;   % �����t�@�C���𕪊����鎞�Ԓ�
paramtype = 3;

% �����x�N�g���擾
[vec_time,vec_param] = ...
    getParameterVector(filename,deltaT,shiftT,fft_size,len_sec,paramtype);

%% �_����쐬
% feedback = 10;
% type_getscore = 1;
% [~,vec_score] = calcScore(vec_time,vec_param,feedback,type_getscore);
% 
% %% ��ʂ̕���_���o
% windowSize = 10;
% dsrate = 10;
% coeff_medfilt = 10;
% filtertype = 1;
% is_plot = 0;
% [T_tmpscene,sf] = cutScene...
%     (vec_time,vec_score,windowSize,coeff_medfilt,filtertype,dsrate,is_plot);
% 
% display([num2str(height(T_tmpscene)),' scenes returned cutScene']);

T_tmpscene = splitScene(vec_time,2);

%% �ގ���ʂ̌���
wg_length = 60;
thr_dist = 2.0;
T_scene = sceneBind(vec_time,vec_param,T_tmpscene,thr_dist,wg_length);
display([num2str(height(T_scene)),' scenes returned sceneBind']);

viewScenes(vec_param,T_scene,1);
T_scene_minsec = time2min_sec(T_scene);

%% �؂�o������ʂ��Ƃ̓_���v�Z
bpm = 88;
bars = 4;
beatperbar = 4;
noteunit = 4;
beat_interval = 60/bpm*(noteunit/beatperbar); % [sec]
aoBeats = bars*beatperbar;
bisample = round(beat_interval*fs); % [sample]
aoSampleLength = bisample*aoBeats; % [sample]
deltaT_calcScore = ceil(beat_interval*aoBeats);
feedback_calcScore = deltaT_calcScore/shiftT;

clear str_scene str_tmp

for i=1:height(T_scene)
    s_start = T_scene.scene_start(i);
    s_end   = T_scene.scene_end(i);
    %T_tmp = T_param((T_param.time>=s_start)&(T_param.time<=s_end),:);
    tv_tmp = vec_time((vec_time>=s_start)&(vec_time<=s_end));
    pv_tmp = vec_param((vec_time>=s_start)&(vec_time<=s_end),:);
    [str_scene(i).score,~] = ...
        calcScore(tv_tmp,pv_tmp,feedback_calcScore,1);
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
sec_pickup = 30;    % in sec
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
tau = 0.1;
% bpm = 85;
% bars = 4;
% beatperbar = 8;
% noteunit = 4;
audio_sample = [];
audio_random = [];
is_plot = 1;

for i=1:length(str_random)
    if isempty(str_random(i).table) == 0
        display(['Scene ',num2str(i),' audio sample generating...']);
        a_tmp = audioread([fname_withoutWAV,'.wav'],...
            [fs*str_random(i).table.s_start(1)+1,...
            fs*str_random(i).table.s_end(1)]);
        a_tmp = (a_tmp(:,1)+a_tmp(:,2))/2;
        audio_sample(i,:) = audioSampleGenerator...
            (a_tmp,fs,tau,bpm,bars,beatperbar,noteunit,is_plot);
        audio_random(i,:) = a_tmp';
    else
        display(['Scene ',num2str(i),' audio sample generate skipped']);
    end
end

%% �I�[�f�B�I�̃m�[�}���C�Y
% norm_power = 0.5;
% audio_sample_norm = [];
% SNratio = [];
% for i=1:length(audio_sample(:,1))
%     audio_sample_norm(i,:) = ...
%         norm_power.*audio_sample(i,:)./max(abs(audio_sample(i,:)));
%     SNratio(i) = max(abs(audio_sample(i,:)))/norm_power;
% end
% 
% audio_sample = audio_sample_norm;

%% �T���v���̃��Y������
audio_noRE = [];
audio_hiRE = [];
audio_loRE = [];
for i=1:length(audio_sample(:,1))
    [audio_noRE(i,:),audio_hiRE(i,:),audio_loRE(i,:)] = ...
        getRhythmEmphasis(audio_sample(i,:),fs,bpm,bars,beatperbar,noteunit);
end

%% ���y�p�T���v���������o��
if is_getaudio == 1
    s = size(audio_sample);
    for i=1:length(audio_sample(:,1))
        wfname1 = [pass,'sample_noRE_scene',num2str(i),'_bpm',num2str(bpm),...
            '_bars',num2str(bars),'_bpb',num2str(beatperbar),'.wav'];
        wfname2 = [pass,'sample_hiRE_scene',num2str(i),'_bpm',num2str(bpm),...
            '_bars',num2str(bars),'_bpb',num2str(beatperbar),'.wav'];
        wfname3 = [pass,'sample_loRE_scene',num2str(i),'_bpm',num2str(bpm),...
            '_bars',num2str(bars),'_bpb',num2str(beatperbar),'.wav'];
        wfname4 = [pass,'sample_nomake_scene',num2str(i),'.wav'];
        audiowrite(wfname1,audio_noRE(i,:),fs);
        audiowrite(wfname2,audio_hiRE(i,:),fs);
        audiowrite(wfname3,audio_loRE(i,:),fs);
        audiowrite(wfname4,audio_random(i,:),fs);
    end
end
