clear all;
%% �O����
fname_withoutWAV = '141121_001';
filename = [fname_withoutWAV,'.WAV'];
a_info = audioinfo(filename);
fs = a_info.SampleRate;
dur = a_info.Duration;
i_stop = ceil(dur/60)-1;

%% �t���[�����Ƃ̃p�����[�^�擾
time = [];      % ����
sp = [];        % �X�y�N�g��
db = [];        % dB (P0=20*10^-6)
cent = [];      % �X�y�N�g���d�S
chro = [];      % �N���}�O����
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
    [t_time,t_sp,t_db,t_cent,t_chro] = soundPickuper_getparameter...
        (fname_withoutWAV,s_start,s_end,deltaT,shiftT,fft_size);
    
    % �ꎞ�ϐ�������
    sp = cat(1,sp,t_sp);
    time = cat(1,time,t_time);
    db = cat(1,db,t_db);
    cent = cat(1,cent,t_cent);
    chro = cat(1,chro,t_chro);
    
    % 1�����Ƃ̃p�����[�^�擾�̌v�Z���Ԃ̌v���I��
    t_part = cputime - t_part;
    display(['�v�Z���Ԃ� ',num2str(t_part),' �b�ł�']);
end
% �p�����[�^�擾�S�̂ł̌v�Z���Ԃ̌v���I��
t_total = cputime - t_total;
display(['�g�[�^���̌v�Z���Ԃ� ',num2str(t_total),' �b�ł�']);

clear t_time t_sp t_db t_cent t_chro t_part t_total s_start s_end;

%% �_���v�Z
[score1,score2] = calcScore(time,db,cent,shiftT);

%%  �e�[�u���쐬
score_total = score1+score2;
T = table(time,db,cent,score1',score2',score_total','VariableNames',...
    {'time','dB','cent','score1','score2','total'});
% T2 = table(time,db,cent,array_med_db',array_sd_db',array_med_cent',array_sd_cent',...
%     'VariableNames',{'time','db','cent','med_db','sd_db','med_cent','sd_cent'});
writetable(T,['T_',fname_withoutWAV,'.csv']);
% writetable(T2,['T2_',fname_withoutWAV,'.csv']);

clear time dB cent score1 score2 total;

%% ��ʂ̐؂�o��
thsld_score = 20;
windowSize = 10;
T_scene = cutScene(T.time,T.score2,thsld_score,windowSize);

%% �����_���s�b�N�A�b�v
% sample_pickup = round(10/shiftT)-1;
% num_pickup = 1000;
% range_time = length(T.time);
% r = range_time-sample_pickup;
% 
% rng('shuffle');
% for i=1:num_pickup
%     R(i) = randi([1,r],1);
%     R_index = R(i):(R(i)+sample_pickup);
%     R_score1(i) = mean(score1(R(i):(R(i)+sample_pickup)));
%     R_score2(i) = mean(score2(R(i):(R(i)+sample_pickup)));
%     time_start(i) = T.time(R(i));
%     time_end(i) = T.time(R(i)+sample_pickup)+shiftT;
% end
% R_score_total = R_score1+R_score2;
% T_random = table(time_start',time_end',R_score1',R_score2',R_score_total',...
%     'VariableNames',{'t_start','t_end','score1','score2','total'});
% T_random = sortrows(T_random,'total','descend');

