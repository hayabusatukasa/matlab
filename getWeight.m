function vw = getWeight(v,w)
% vw = getWeight(v,w)
% �d�݂̓K�p�֐�
% 
% Input:
% 	v	: �d�݂Â��O�̃x�N�g��
% 	w	: �d��
%
% Output:
% 	vw	: �d�݂Â����ꂽ�x�N�g��

if w>1
    vw = log(v)./log(w);
elseif w==1
    vw = log(v)./log(1.1);
else
    vw = log(v)./log(w);
end
end
