function [score1,score2] = calcScore3(time,db,cent,shiftT)
% �X�R�A2�̕��ςƕW���΍����Ƃ�f�[�^�̊Ԋu in sample
sec = 30/shiftT;    

[~,q1_db,q2_db,q3_db,~] = quantile(db);
[~,q1_cent,q2_cent,q3_cent,~] = quantile(cent);

len = length(time);
for i=1:len
    % �X�R�A1�̌v�Z
    score1_db(i) = detcurve2(db(i),q1_db,q2_db,q3_db);
    score1_cent(i) = detcurve2(cent(i),q1_cent,q2_cent,q3_cent);
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
    
    % ����Ԃ̒����l�C�W���΍����Ƃ�
    [~,q1_tmp_db,q2_tmp_db,q3_tmp_db,~] = quantile(tmp_db);
    [~,q1_tmp_cent,q2_tmp_cent,q3_tpm_cent,~] = quantile(tmp_cent);
    
    % �X�R�A2�̌v�Z
    score2_db(i) = detcurve2(db(i),q1_tmp_db,q2_tmp_db,q3_tmp_db);
    score2_cent(i)= detcurve2(cent(i),q1_tmp_cent,q2_tmp_cent,q3_tpm_cent);
    score2(i) = getscore(score2_db(i),score2_cent(i));
end
end