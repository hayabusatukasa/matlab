function [score1,score2] = calcScore4(time,db,cent,deltaT,shiftT,type_getscore)
% ��ԑS�̂ł̃X�R�A�ƁC�e�C���f�b�N�X���ƂɈ���Ԃł̃X�R�A���v�Z����֐�
% ver4 : 
%   �t���[���]���֐��ɕ��ʐ���p�������̂��g�p
%   score2�̌v�Z�ɉߋ�deltaT�b�̋�ԂŌv�Z����悤�ɐݒ�
%   getscore��type��2�ɕύX
%
% Input
%   time    : ���ԗ�
%   db      : �f�V�x���p�����[�^��
%   cent    : �X�y�N�g���d�S�p�����[�^��
%   deltaT  : ����Ԃ��Ƃ�b��
%   shiftT  : ���Ԃ̃V�t�g��
%
% Output
%   score1  : ��ԑS�̂ł̃X�R�A
%   score2  : ����Ԃł̃X�R�A

% �X�R�A2�̕��ςƕW���΍����Ƃ�f�[�^�̊Ԋu in sample
smpls = deltaT/shiftT;    

[~,q1_db,q2_db,q3_db,~] = quantile(db);
[~,q1_cent,q2_cent,q3_cent,~] = quantile(cent);

len_time = length(time);
len_max = len_time;
for i=1:len_time
    % �X�R�A1�̌v�Z
    score1_db(i) = detcurve2(db(i),q1_db,q2_db,q3_db);
    score1_cent(i) = detcurve2(cent(i),q1_cent,q2_cent,q3_cent);
    score1(i) = getscore(score1_db(i),score1_cent(i),type_getscore);
    
    % ���݂̃C���f�b�N�X�𒆐S�Ƃ��āC����Ԃ��Ƃ�
    if i>smpls && i<=len_max
        tmp_db = db((i-smpls+1):i);
        tmp_cent = cent((i-smpls+1):i);
    elseif i<=smpls && i<=len_max
        tmp_db = db(1:smpls);
        tmp_cent = cent(1:smpls);
    else
        tmp_db = db;
        tmp_cent = cent;
    end
    
    % ����Ԃ̒����l�C�W���΍����Ƃ�
    [~,q1_tmp_db,q2_tmp_db,q3_tmp_db,~] = quantile(tmp_db);
    [~,q1_tmp_cent,q2_tmp_cent,q3_tpm_cent,~] = quantile(tmp_cent);
    
    % �X�R�A2�̌v�Z
    score2_db(i) = detcurve2(db(i),q1_tmp_db,q2_tmp_db,q3_tmp_db);
    score2_cent(i)= detcurve2(cent(i),q1_tmp_cent,q2_tmp_cent,q3_tpm_cent);
    score2(i) = getscore(score2_db(i),score2_cent(i),type_getscore);
end
end