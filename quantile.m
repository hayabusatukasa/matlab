function [min,q1,q2,q3,max] = quantile(x)
% [min,q1,q2,q3,max] = quantile(x)
% 1次元のベクトルから四分位点を取得する関数
% Input:
% 	x	: 1次元のベクトル
% 
% Output:
%	min	: 最小値
% 	q1	: 第1四分位点
% 	q2	: 第2四分位点
% 	q3	: 第3四分位点
% 	max	: 最大値

len = length(x);
x_sort = sort(x);
min = x_sort(1);
max = x_sort(end);
if mod(len,2)==1
    mi = (len+1)/2;
    q2 = x_sort(mi);
    q1 = median(x_sort(1:mi));
    q3 = median(x_sort(mi:end));
else
    mi = len/2;
    q2 = (x_sort(mi)+x_sort(mi+1))/2;
    q1 = median(x_sort(1:mi));
    q3 = median(x_sort((mi+1):end));
end
end
