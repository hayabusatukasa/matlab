function score = calcScore2(time,db,cent,shiftT)
% �X�R�A2�̒����l�ƕW���΍����Ƃ�f�[�^�̊Ԋu in sample
sec = 30/shiftT;    

% ���ȏ��dB�����C���f�b�N�X�݂̂����o��
P0 = 2e-5;
thsld_amp = 0;                       % threshold in amplitude
thsld_db = 10*log10(thsld_amp^2/P0^2);  % in db
upperthsld = (db>=thsld_db);
db_upperthsld = db(upperthsld);
cent_upperthsld = cent(upperthsld);

len = length(time);
for i=1:len
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
        me_tmp_db = 0;
        sd_tmp_db = 0;
        me_tmp_cent = 0;
        sd_tmp_cent = 0;
    else
        me_tmp_db = median(tmp_db);
        sd_tmp_db = std(tmp_db);
        me_tmp_cent = median(tmp_cent);
        sd_tmp_cent = std(tmp_cent);
    end
    
    % �X�R�A2�̌v�Z
    score_db(i) = detcurve(db(i),me_tmp_db,sd_tmp_db);
    score_cent(i)= detcurve(cent(i),me_tmp_cent,sd_tmp_cent);
    score(i) = getscore(score_db(i),score_cent(i));
end
end