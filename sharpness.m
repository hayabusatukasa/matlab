function S = sharpness(BarkAxis,N_specif,N_tot)
% sharpnessを計算する関数
%     BarkAxis    : Bark軸の配列
%     N_specif    : Barkに対してのラウドネス
%     N_tot       : ラウドネス面積

% 計算手法は次の論文を参考にしている
% - 
% 人に優しい家電製品や自動車などの音響デザインに関する研究
% 章 忠（豊橋技術科学大学）

w = zeros(1,length(BarkAxis));  % 重みの初期化
C = 0.11;   % 定数

% 重みの計算
for i=1:length(BarkAxis)
    w(i) = sharpness_weight(BarkAxis(i));
end

numerator = N_specif.*w.*BarkAxis;
S = C * sum(numerator) / N_tot;
end