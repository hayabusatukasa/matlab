function result = sharpness_weight(z)
% sharpnessの重み係数を計算する関数
% 計算手法は次の論文を参考にしている
% - 
% 人に優しい家電製品や自動車などの音響デザインに関する研究
% 章 忠（豊橋技術科学大学）
if z < 14
    result =  1;
else
    result = 0.00012*z*z*z*z - 0.0056*z*z*z + 0.1*z*z - 0.81*z + 3.51;
end
end