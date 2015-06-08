function result = getScoreResult(t_score,type)
% result = getScoreResult(t_score,type)
% スコア計算関数（max:100，min:0）
% Input:
%	t_score	: パラメータごとのスコア
%	type 	: スコア計算方法
%
% Output:
%	result	: スコア計算結果

if nargin<2
    type = 1;
end

switch type
    case 1
        result = 100*prod(t_score);
    otherwise
        result = 100*prod(t_score);
end
end
