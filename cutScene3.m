function [T_scene,sf] = cutScene3...
    (T_param,windowSize,coeff_medfilt,filtertype,is_scenebind)
% ver3 極小値から場面の転換点を検出する
     
time = T_param.time;
score = T_param.score;

% 移動平均フィルタの適用
if filtertype == 1 % basic moving average
    sf = movingAverage(score,windowSize);
elseif filtertype == 2 % sgolayfilter and medianfilter
    coeff_sgolayfilt = windowSize;
    % coeff_medfilt = 5;
    sf = medSgolayfilt(score,coeff_sgolayfilt,coeff_medfilt);
end

% 平滑化された信号のダウンサンプリング
dsrate = 120; % ダウンサンプリングレート
sfds = resample(sf,1,dsrate);

% ダウンサンプリングされた信号の極小値の抽出
[~,locs_valley_sfds] = getPeakValley(sfds,1,-Inf,-Inf,0,0,0);

% 得られた極小値から元のサンプリングレートでの位置をとり，場面を検出
usrate = floor(length(sf)/length(sfds)); % アップサンプリングレート
scene_start(1) = time(1);
scene_end(1) = time(locs_valley_sfds(1)*usrate);
if length(locs_valley_sfds)>1
    for i=2:length(locs_valley_sfds)
        scene_start(i) = time(locs_valley_sfds(i-1)*usrate);
        scene_end(i) = time(locs_valley_sfds(i)*usrate);
    end
    scene_start(i+1) = time(locs_valley_sfds(i)*usrate);
    scene_end(i+1) = time(length(sfds)*usrate);
end

% テーブル作成
T_scene = table(scene_start',scene_end','VariableNames',...
    {'scene_start','scene_end'});

% 短くとりすぎた場面を隣接する場面と結合する
if is_scenebind==1
    T_scene = sceneBind2(T_param,T_scene);
end

