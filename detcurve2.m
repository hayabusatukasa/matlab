function result = detcurve2(x,q1,q2,q3)
% result = detcurve2(x,q1,q2,q3)
% シグモイド関数を用いた評価関数
% Input:
%  	x 		: 変数
%	q1		: 第1四分位点
%	q2		: 第2四分位点
%	q3		: 第3四分位点
%
% Output:
%	result	: 評価関数適用後の値

% 1/(1+exp(-a*sd))->1よりexp(-a*sd)=0.001となるaを求める
% -a*sd = log(0.001) = -6.9078
nearZero = 0.001;
sd1 = q2-q1;
sd2 = q3-q2;
a1 = -log(nearZero)/sd1;
a2 = -log(nearZero)/sd2;

if x<=q2
    result = 1/(1+exp(-a1*(x-q2+sd1)));
else
    result = 1/(1+exp(a2*(x-q2-sd2)));
end
end
