function [T_scene,sf] = cutScene3...
    (T_param,windowSize,coeff_medfilt,filtertype,dsrate,is_plot)
% 
%
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
% dsrate = 120; % ダウンサンプリングレート
sfds = downsample(sf,dsrate);

% ダウンサンプリングされた信号の極小値の抽出
[~,locs_valley_sfds] = getPeakValley(sfds,1,-Inf,-Inf,0,0,0);

% 得られた極小値から元のサンプリングレートでの位置をとり，場面を検出
usrate = dsrate; %floor(length(sf)/length(sfds)); % アップサンプリングレート
sfrs = interp(sfds,usrate);
sfrs = sfrs(1:length(sf));
locs_valley_us = locs_valley_sfds * usrate - usrate;
scene_start(1) = time(1);
scene_end(1) = time(locs_valley_us(1));
if length(locs_valley_sfds)>1
    for i=2:length(locs_valley_sfds)
        scene_start(i) = time(locs_valley_us(i-1));
        scene_end(i) = time(locs_valley_us(i));
    end
    scene_start(i+1) = time(locs_valley_us(i));
    scene_end(i+1) = time(length(sf));
end

% テーブル作成
T_scene = table(scene_start',scene_end','VariableNames',...
    {'scene_start','scene_end'});

% 短くとりすぎた場面を隣接する場面と結合する
% if is_scenebind==1
%     [T_scene,d] = sceneBind4(T_param,T_scene,1.0);
% end
% 
% if is_scenebind==2
%     [T_scene,d] = sceneBind3(T_param,T_scene,10);
% end

if is_plot==1
    figure;
    plot(sf); hold all;
    plot(sfrs);
    stem(locs_valley_us,sfrs(locs_valley_us));
    hold off;
    title(['Moving Average FrameLength= ',num2str(windowSize),' DownsamplingRate = ',num2str(dsrate)]);
    xlabel('Sample');
    legend('Moving average','Downsample','Valley');
end
end