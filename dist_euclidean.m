function res = dist_euclidean(x1,x2)
% res = dist_euclidean(x1,x2)
% ユークリッド距離を求める関数
%
% Input:
%	x1	: ベクトル1
%	x2	: ベクトル2
%
% Output:
% 	res : 計算結果

if length(x1)~=length(x2)
    error('ベクトルが同じ長さではありません');
end

res = sqrt(sum((x1-x2).^2));
end
