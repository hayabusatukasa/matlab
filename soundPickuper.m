clear all;
%% �O����
fname_withoutWAV = '141029_001';
filename = [fname_withoutWAV,'.WAV'];
a_info = audioinfo(filename);
i_stop = floor(a_info.Duration/60)-1;

%% �t���[�����Ƃ̃p�����[�^�擾
t_total = cputime;
time = [];
rms = [];
cent = [];
for i=0:i_stop
    t_part = cputime;
    display(['calculating ',num2str(i),' to ',num2str(i+1)]);
    [t_time,t_rms,t_cent] = soundPickuper_getparameter...
        (fname_withoutWAV,i*60,(i+1)*60+0.5);
    time = cat(1,time,t_time);
    rms = cat(1,rms,t_rms);
    cent = cat(1,cent,t_cent);
    t_part = cputime - t_part;
    display(['�v�Z���Ԃ� ',num2str(t_part),' �b�ł�']);
end
t_total = cputime - t_total;
display(['�g�[�^���̌v�Z���Ԃ� ',num2str(t_total),' �b�ł�']);

%% �_���v�Z
sec = 60;   % �X�R�A2�̒����l�ƕW���΍����Ƃ�f�[�^�̊Ԋu in sample
med_rms = median(rms);
sd_rms = std(rms);
med_cent = median(cent);
sd_cent = std(cent);
for i=1:length(time)
    % �X�R�A1�̌v�Z
    score1_rms(i) = detcurve(rms(i),med_rms,sd_rms);
    score1_cent(i) = detcurve(cent(i),med_cent,sd_cent);
    score1(i) = getscore(score1_rms(i),score1_cent(i));
    
    % �X�R�A2�̌v�Z
    len = length(time);
    if i>sec && i<=(len-sec)
        tmp_rms = rms((i-sec):(i+sec));
        tmp_cent = cent((i-sec):(i+sec));
    elseif i<=sec && i<=(len-sec)
        tmp_rms = [rms(1:i);rms((i+1):(i+sec))];
        tmp_cent = [cent(1:i);cent((i+1):(i+sec))];
    elseif i>sec && i>(len-sec)
        tmp_rms = [rms((i-sec):(i-1));rms(i:len)];
        tmp_cent = [cent((i-sec):(i-1));cent(i:len)];
    end
    med_tmp_rms = median(tmp_rms);
    sd_tmp_rms = std(tmp_rms);
    med_tmp_cent = median(tmp_cent);
    sd_tmp_cent = std(tmp_cent);
    score2_rms(i) = detcurve(rms(i),med_tmp_rms,sd_tmp_rms);
    score2_cent(i)= detcurve(cent(i),med_tmp_cent,sd_tmp_cent);
    score2(i) = getscore(score2_rms(i),score2_cent(i));
end
