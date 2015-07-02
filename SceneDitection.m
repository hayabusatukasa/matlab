function T_scene = SceneDitection(filename,is_plot,ditect_type,wg_length,thr_dist)
% 音声ファイルから場面を取得する関数
% T_scene = SceneDitection(filename,is_plot,ditect_type,wg_length,thr_dist)
% Inputs
%     filename    : オーディオファイル名
%     is_plot     : 場面検出結果を表示するかどうか[0:No(default) 1:Yes]
%     ditect_type : 場面候補処理の方法
%                   [0:スコア算出と移動平均フィルタ処理(default) 
%                    other:極小場面候補の生成]
%     wg_length   : 重み付けの基準となる場面の時間長（秒）[default:60]
%     thr_dist    : 場面が結合されるパラメータ距離のしきい値[default:1.0]
% Outputs
%     T_scene     : 場面開始地点と終了地点のテーブル（秒）
%

%% 引数設定
if nargin<2; is_plot=0; end
if nargin<3; ditect_type=0; end
if nargin<4; wg_length=60; end
if nargin<5; thr_dist=1.0; end

%% 特徴ベクトル取得
deltaT = 1.0;   % フレーム分解能
shiftT = 0.5;   % フレームシフト長
fft_size = 2^15;% FFTサイズ
len_sec = 60;   % 音声ファイルを分割する時間長
paramtype = 1;  % 場面検出用のパラメータ

[vec_time,vec_param] = ...
    getParameterVector(filename,deltaT,shiftT,fft_size,len_sec,paramtype);

%% 場面候補の作成
if ditect_type==0
    % 点数列作成
    feedback = 10;      % 点数を求める基準となるフレーム数
    type_getscore = 1;  % 点数の計算方法
    [~,vec_score] = calcScore(vec_time,vec_param,feedback,type_getscore);
    
    % 場面の分岐点検出による一時的な場面候補の検出
    windowSize = 10;    % 移動平均フィルタのタップ長
    dsrate = 10;        % 包絡線のダウンサンプリングレート
    coeff_medfilt = 10; % メディアンフィルタのタップ長
    filtertype = 1;     % フィルタの種類（1:移動平均フィルタ，2:sgolaymedianフィルタ）
    [T_tmpscene,~] = cutScene...
        (vec_time,vec_score,windowSize,coeff_medfilt,filtertype,dsrate,0);
else
    % 長さの均一な短い場面候補を作成
    T_tmpscene = splitScene(vec_time,2);
end

%% 類似場面の結合
%wg_length = 60; % 重み付けがなされる場面の長さ
%thr_dist = 1.0; % 場面を分割する距離のしきい値
T_scene = sceneBind(vec_time,vec_param,T_tmpscene,thr_dist,wg_length);
display([num2str(height(T_scene)),' scenes returned sceneBind']);
T_scene.scene_start = floor(T_scene.scene_start);
T_scene.scene_end = floor(T_scene.scene_end);
if is_plot==1
    viewScenes(vec_param,T_scene,length(vec_param(1,:)));
end

end