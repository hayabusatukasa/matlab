function [score1,score2] = calcScore(vec_time,vec_param,feedback,type_getscore)
% [score1,score2] = calcScore(vec_time,vec_param,feedback,type_getscore)
% 区間全体でのスコアと，各インデックスごとに一定区間でのスコアを計算する関数
% Input:
% 	vec_time	: 時間ベクトル
% 	vec_param	: 特徴ベクトル
% 	feedback	: 一定区間のサンプル長
% 	type_getscore: スコアの計算方式(default=1)
% 
% Output:
%	score1 		: 区間全体でのスコア列
%	score2		: 一定区間でのスコア列

if nargin<4
	type_getscore=1;
end

if feedback > length(vec_time)
    score1 = [];
    score2 = [];
    return;
end

[~,pvdim] = size(vec_param); % 特徴ベクトルの次元数

% パラメータ全体での四分位点を取得
for i=1:pvdim
    [~,q1_pv(i),q2_pv(i),q3_pv(i),~] = quantile(vec_param(:,i));
end

len_time = length(vec_time);
len_max = len_time;
for i=1:len_time
    % スコア1の計算
    for j=1:pvdim
        t_score1(j) = detcurve2(vec_param(i,j),q1_pv(j),q2_pv(j),q3_pv(j));
    end
    score1(i) = getScoreResult(t_score1);
    
    % 現在のインデックスを中心として，一定区間をとる
    if i>feedback && i<=len_max
        tmp_pv = vec_param((i-feedback+1):i,:);
    elseif i<=feedback && i<=len_max
        tmp_pv = vec_param(1:feedback,:);
    else
        tmp_pv = vec_param;
    end
    
    % 一定区間のパラメータの四分位点をとる
    for j=1:pvdim
        [~,q1_tmp_pv(j),q2_tmp_pv(j),q3_tmp_pv(j),~] = quantile(tmp_pv(:,j));
    end
    
    % スコア2の計算
    for j=1:pvdim
        t_score2(j) = detcurve2(vec_param(i,j),q1_tmp_pv(j),q2_tmp_pv(j),q3_tmp_pv(j));
    end
    score2(i) = getScoreResult(t_score2);
end

score1 = score1';
score2 = score2';

end
