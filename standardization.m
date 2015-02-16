function y=standardization(x)
% y = standardization(x)
% 1次元ベクトルの平均0，分散1への標準化
%
% Input:
%	x	: 1次元ベクトル
%
% Output:
%	y	: 標準化されたベクトル
%

y = (x-mean(x))/std(x);
end
