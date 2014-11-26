function result = detcurve(x,m,sd)
% シグモイド関数を用いた評価関数
% 引数
% x : 変数
% m : 平均，もしくは中央値
% sd: 標準偏差

% 1/(1+exp(-a*sd))->1よりexp(-a*sd)=0.001となるaを求める
% -a*sd = log(0.001) = -6.9078
a = 6.9078/sd;
if x<=m
    result = 1/(1+exp(-a*(x-m+sd)));
else
    result = 1/(1+exp(a*(x-m-sd)));
end
end