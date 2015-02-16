function vw = getWeight(v,w)
% vw = getWeight(v,w)
% 重みの適用関数
% 
% Input:
% 	v	: 重みづけ前のベクトル
% 	w	: 重み
%
% Output:
% 	vw	: 重みづけされたベクトル

if w>1
    vw = log(v)./log(w);
elseif w==1
    vw = log(v)./log(1.1);
else
    vw = log(v)./log(w);
end
end
