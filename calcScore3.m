function [score1,score2] = calcScore3(time,db,cent,deltaT,shiftT)
% 区間全体でのスコアと，各インデックスごとに一定区間でのスコアを計算する関数
% ver3 : フレーム評価関数に分位数を用いたものを使用
%
% Input
%   time    : 時間列
%   db      : デシベルパラメータ列
%   cent    : スペクトル重心パラメータ列
%   deltaT  : 一定区間をとる秒数
%   shiftT  : 時間のシフト長
%
% Output
%   score1  : 区間全体でのスコア
%   score2  : 一定区間でのスコア

% スコア2の平均と標準偏差をとるデータの間隔 in sample
smpls = deltaT/shiftT;    

[~,q1_db,q2_db,q3_db,~] = quantile(db);
[~,q1_cent,q2_cent,q3_cent,~] = quantile(cent);

len_time = length(time);
len_max = len_time-smpls;
for i=1:len_time
    % スコア1の計算
    score1_db(i) = detcurve2(db(i),q1_db,q2_db,q3_db);
    score1_cent(i) = detcurve2(cent(i),q1_cent,q2_cent,q3_cent);
    score1(i) = getscore(score1_db(i),score1_cent(i));
    
    % 現在のインデックスを中心として，一定区間をとる
    if i>smpls && i<=len_max
        tmp_db = db((i-smpls):(i+smpls));
        tmp_cent = cent((i-smpls):(i+smpls));
    elseif i<=smpls && i<=len_max
        tmp_db = [db(1:i);db((i+1):(i+smpls))];
        tmp_cent = [cent(1:i);cent((i+1):(i+smpls))];
    elseif i>smpls && i>len_max
        tmp_db = [db((i-smpls):(i-1));db(i:len_time)];
        tmp_cent = [cent((i-smpls):(i-1));cent(i:len_time)];
    else
        tmp_db = db;
        tmp_cent = cent;
    end
    
    % 一定区間の中央値，標準偏差をとる
    [~,q1_tmp_db,q2_tmp_db,q3_tmp_db,~] = quantile(tmp_db);
    [~,q1_tmp_cent,q2_tmp_cent,q3_tpm_cent,~] = quantile(tmp_cent);
    
    % スコア2の計算
    score2_db(i) = detcurve2(db(i),q1_tmp_db,q2_tmp_db,q3_tmp_db);
    score2_cent(i)= detcurve2(cent(i),q1_tmp_cent,q2_tmp_cent,q3_tpm_cent);
    score2(i) = getscore(score2_db(i),score2_cent(i));
end
end