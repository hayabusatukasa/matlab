clear all;
%% �O����
fname_withoutWAV = '141121_001';
filename = [fname_withoutWAV,'.WAV'];
pass = ['\Users\Shunji\Music\RandomPickup\'];
a_info = audioinfo(filename);
fs = a_info.SampleRate;
dur = a_info.Duration;
i_stop = ceil(dur/60)-1;

is_getaudio = 1;

%% �t���[�����Ƃ̃p�����[�^�擾
time = [];      % ����
db = [];        % dB (P0=20*10^-6)
cent = [];      % �X�y�N�g���d�S
deltaT = 1.0;   % �t���[������\
shiftT = 0.5;   % �t���[���V�t�g��
fft_size = 2^15;% FFT�T�C�Y
P0 = 2e-5;      % dB�v�Z�ɂ�����P0

% �p�����[�^�擾�S�̂ł̌v�Z���Ԃ̌v���J�n
t_total = cputime;
for i=0:i_stop
    % 1�����Ƃ̃p�����[�^�擾�̌v�Z���Ԃ̌v���J�n
    t_part = cputime;
    display(['calculating ',num2str(i),' to ',num2str(i+1)]);

    % 60�b���ƂɃp�����[�^�擾�֐��ɓ��邪�C�����ŃI�[�o�[���Ȃ��悤�ɂ���
    if (dur-i*60)<60
        interval = floor(dur)-i*60;
        s_start = i*60;
        s_end = s_start+interval;
    else
        s_start = i*60;
        s_end = (i+1)*60+shiftT;
    end
    
    % �p�����[�^�擾���C�ꎞ�ϐ��Ɋi�[
    [t_time,t_db,t_cent] = soundPickuper_getparameter...
        (fname_withoutWAV,s_start,s_end,deltaT,shiftT,fft_size);
    
    % �ꎞ�ϐ�������
    time = cat(1,time,t_time);
    db = cat(1,db,t_db);
    cent = cat(1,cent,t_cent);
    
    % 1�����Ƃ̃p�����[�^�擾�̌v�Z���Ԃ̌v���I��
    t_part = cputime - t_part;
    display(['�v�Z���Ԃ� ',num2str(t_part),' �b�ł�']);
end
% �p�����[�^�擾�S�̂ł̌v�Z���Ԃ̌v���I��
t_total = cputime - t_total;
display(['�g�[�^���̌v�Z���Ԃ� ',num2str(t_total),' �b�ł�']);

clear t_time t_db t_cent t_part t_total s_start s_end;

%% �_���v�Z
deltaT_calcScore = 10;
type_getscore = 1;
[~,score] = calcScore4(time,db,cent,deltaT_calcScore,shiftT,type_getscore);

%%  �e�[�u���쐬
T_param = table(time,db,cent,score','VariableNames',...
    {'time','dB','cent','score'});

%% ��ʂ̐؂�o��
windowSize = 31;
coeff_medfilt = 10;
[T_scene,sf,thsld_hi,thsld_low] = ...
    cutScene2(T_param.time,T_param.score,windowSize,coeff_medfilt,2,1,0);

% plot
plotScene(T_param,T_scene,sf,thsld_low,thsld_hi,windowSize);

%% �؂�o������ʂ��Ƃ̓_���v�Z
for i=1:height(T_scene)
    s_start = T_scene.scene_start(i);
    s_end   = T_scene.scene_end(i);
    T_tmp = T_param((T_param.time>=s_start)&(T_param.time<=s_end),:);
    [str_scene(i).score,~] = ...
        calcScore3(T_tmp.time,T_tmp.dB,T_tmp.cent,deltaT_calcScore,shiftT);
    str_scene(i).time  = T_tmp.time';
end

%% �؂�o������ʂ��Ƃ̑f�ޕ����������_���Ɏ��o��
num_pickup = 100;
sec_pickup = 30;    % in sec
sample_pickup = sec_pickup/shiftT;    % in sample

str_random = randomPickup(str_scene,num_pickup,sample_pickup);

%% �I�[�f�B�I�f�ނ����y�p�T���v���Ɏd�グ��
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

%% ���y�p�T���v���������o��
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

