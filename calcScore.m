function [score1,score2] = calcScore(vec_time,vec_param,feedback,type_getscore)
% [score1,score2] = calcScore(vec_time,vec_param,feedback,type_getscore)
% ��ԑS�̂ł̃X�R�A�ƁC�e�C���f�b�N�X���ƂɈ���Ԃł̃X�R�A���v�Z����֐�
% Input:
% 	vec_time	: ���ԃx�N�g��
% 	vec_param	: �����x�N�g��
% 	feedback	: ����Ԃ̃T���v����
% 	type_getscore: �X�R�A�̌v�Z����(default=1)
% 
% Output:
%	score1 		: ��ԑS�̂ł̃X�R�A��
%	score2		: ����Ԃł̃X�R�A��

if nargin<4
	type_getscore=1;
end

if feedback > length(vec_time)
    score1 = [];
    score2 = [];
    return;
end

[~,pvdim] = size(vec_param); % �����x�N�g���̎�����

% �p�����[�^�S�̂ł̎l���ʓ_���擾
for i=1:pvdim
    [~,q1_pv(i),q2_pv(i),q3_pv(i),~] = quantile(vec_param(:,i));
end

len_time = length(vec_time);
len_max = len_time;
for i=1:len_time
    % �X�R�A1�̌v�Z
    for j=1:pvdim
        t_score1(j) = detcurve2(vec_param(i,j),q1_pv(j),q2_pv(j),q3_pv(j));
    end
    score1(i) = getScoreResult(t_score1);
    
    % ���݂̃C���f�b�N�X�𒆐S�Ƃ��āC����Ԃ��Ƃ�
    if i>feedback && i<=len_max
        tmp_pv = vec_param((i-feedback+1):i,:);
    elseif i<=feedback && i<=len_max
        tmp_pv = vec_param(1:feedback,:);
    else
        tmp_pv = vec_param;
    end
    
    % ����Ԃ̃p�����[�^�̎l���ʓ_���Ƃ�
    for j=1:pvdim
        [~,q1_tmp_pv(j),q2_tmp_pv(j),q3_tmp_pv(j),~] = quantile(tmp_pv(:,j));
    end
    
    % �X�R�A2�̌v�Z
    for j=1:pvdim
        t_score2(j) = detcurve2(vec_param(i,j),q1_tmp_pv(j),q2_tmp_pv(j),q3_tmp_pv(j));
    end
    score2(i) = getScoreResult(t_score2);
end

score1 = score1';
score2 = score2';

end
