function res = dist_euclidean(x1,x2)
% res = dist_euclidean(x1,x2)
% ���[�N���b�h���������߂�֐�
%
% Input:
%	x1	: �x�N�g��1
%	x2	: �x�N�g��2
%
% Output:
% 	res : �v�Z����

if length(x1)~=length(x2)
    error('�x�N�g�������������ł͂���܂���');
end

res = sqrt(sum((x1-x2).^2));
end
