function y=standardization(x)
% y = standardization(x)
% 1�����x�N�g���̕���0�C���U1�ւ̕W����
%
% Input:
%	x	: 1�����x�N�g��
%
% Output:
%	y	: �W�������ꂽ�x�N�g��
%

y = (x-mean(x))/std(x);
end
