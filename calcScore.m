function [score1,score2] = calcScore(time,db,cent,shiftT)
% �X�R�A2�̒����l�ƕW���΍����Ƃ�f�[�^�̊Ԋu in sample
sec = 30/shiftT;    

% ���ȏ��dB�����C���f�b�N�X�݂̂����o��
P0 = 2e-5;
thsld_amp = 0;                       % threshold in amplitude
thsld_db = 10*log10(thsld_amp^2/P0^2);  % in db
upperthsld = (db>=thsld_db);
db_upperthsld = db(upperthsld);
cent_upperthsld = cent(upperthsld);

% �X�R�A1�̌v�Z�ɗp����C�S�̂������Ƃ��̒����l�ƕW���΍�
med_db = median(db_upperthsld);
sd_db = std(db_upperthsld);
med_cent = median(cent_upperthsld);
sd_cent = std(cent_upperthsld);

len = length(time);
for i=1:len
    % �X�R�A1�̌v�Z
    score1_db(i) = detcurve(db(i),med_db,sd_db);
    score1_cent(i) = detcurve(cent(i),med_cent,sd_cent);
    score1(i) = getscore(score1_db(i),score1_cent(i));
    
    % ���݂̃C���f�b�N�X�𒆐S�Ƃ��āC����Ԃ��Ƃ�
    if i>sec && i<=(len-sec)
        tmp_db = db((i-sec):(i+sec));
        tmp_cent = cent((i-sec):(i+sec));
    elseif i<=sec && i<=(len-sec)
        tmp_db = [db(1:i);db((i+1):(i+sec))];
        tmp_cent = [cent(1:i);cent((i+1):(i+sec))];
    elseif i>sec && i>(len-sec)
        tmp_db = [db((i-sec):(i-1));db(i:len)];
        tmp_cent = [cent((i-sec):(i-1));cent(i:len)];
    end
    
    tmp_upperthsld = (tmp_db>=thsld_db);
    tmp_db = tmp_db(tmp_upperthsld);
    tmp_cent = tmp_cent(tmp_upperthsld);
    
    % ����Ԃ̒����l�C�W���΍����Ƃ�
    if isempty(tmp_db)
        med_tmp_db = 0;
        sd_tmp_db = 0;
        med_tmp_cent = 0;
        sd_tmp_cent = 0;
    else
        med_tmp_db = median(tmp_db);
        sd_tmp_db = std(tmp_db);
        med_tmp_cent = median(tmp_cent);
        sd_tmp_cent = std(tmp_cent);
    end
    array_med_db(i) = med_tmp_db;
    array_sd_db(i) = sd_tmp_db;
    array_med_cent(i) = med_tmp_cent;
    array_sd_cent(i) = sd_tmp_cent;
    
    % �X�R�A2�̌v�Z
    score2_db(i) = detcurve(db(i),med_tmp_db,sd_tmp_db);
    score2_cent(i)= detcurve(cent(i),med_tmp_cent,sd_tmp_cent);
    score2(i) = getscore(score2_db(i),score2_cent(i));
end
end