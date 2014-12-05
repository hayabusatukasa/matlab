clear all;
%% �O����
fname_withoutWAV = '141029_001';
filename = [fname_withoutWAV,'.WAV'];
pass = ['\Users\Shunji\Music\RandomPickup\'];
a_info = audioinfo(filename);
fs = a_info.SampleRate;
dur = a_info.Duration;
i_stop = ceil(dur/60)-1;

%% �t���[�����Ƃ̃p�����[�^�擾
time = [];      % ����
sp = [];        % �X�y�N�g��
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
    [t_time,t_sp,t_db,t_cent] = soundPickuper_getparameter...
        (fname_withoutWAV,s_start,s_end,deltaT,shiftT,fft_size);
    
    % �ꎞ�ϐ�������
    sp = cat(1,sp,t_sp);
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

clear t_time t_sp t_db t_cent t_part t_total s_start s_end;

%% �_���v�Z
score = calcScore2(time,db,cent,shiftT);

%%  �e�[�u���쐬
T_param = table(time,db,cent,score','VariableNames',...
    {'time','dB','cent','score'});

clear time dB cent score1;

%% ��ʂ̐؂�o��
thsld_score1 = 42;
thsld_score2 = 55;
windowSize = 60;
[T_scene,sf] = cutScene(T_param.time,T_param.score,...
    thsld_score1,thsld_score2,windowSize);

% plot
t = T_param.time((windowSize+1):end);
tt = linspace(0,T_scene.scene_end(end),T_scene.scene_end(end)*2+1);
figure;
plot(t,sf((windowSize+1):end)); 
hold all;
plot(t,linspace(thsld_score1,thsld_score1,length(t)));
plot(t,linspace(thsld_score2,thsld_score2,length(t)));
for i=1:height(T_scene)
    tmp = (tt>=T_scene.scene_start(i))&(tt<=T_scene.scene_end(i));
    tmp = tmp*mean([thsld_score1 thsld_score2]);
    plot(tt,tmp);
end
hold off;
title(['filter-',num2str(windowSize)]);
xlim([0,T_param.time(end)]);

%% �؂�o������ʂ��Ƃ̓_���v�Z
for i=1:height(T_scene)
    s_start = T_scene.scene_start(i);
    s_end   = T_scene.scene_end(i);
    T_tmp = T_param((T_param.time>=s_start)&(T_param.time<=s_end),:);
    str_scene(i).score = calcScore1(T_tmp.time,T_tmp.dB,T_tmp.cent);
    str_scene(i).time  = T_tmp.time';
end

%% �؂�o������ʂ��Ƃ̑f�ޕ������o��
num_pickup = 100;
sec_pickup = 10;    % in sec
sample_pickup = sec_pickup/shiftT;    % in sample

str_random = randomPickup(str_scene,num_pickup,sample_pickup);

%% �I�яo���ꂽ�������特���f�[�^���擾
for i=1:length(str_random)
    if isempty(str_random(i).table) == 0
        a_tmp = audioread([fname_withoutWAV,'.wav'],...
            [fs*str_random(i).table.s_start(1)+1,fs*str_random(i).table.s_end(1)]);
        a_tmp = (a_tmp(:,1)+a_tmp(:,2))/2;
        audio(i,:) = a_tmp;
        s_tmp = floor(str_random(i).table.s_start(1));
        e_tmp = floor(str_random(i).table.s_end(1));
        wfname = [pass,'scene',num2str(i),...
            '_time',num2str(s_tmp),'-',num2str(e_tmp),'.wav'];
        audiowrite(wfname,a_tmp,fs);
    end
end
