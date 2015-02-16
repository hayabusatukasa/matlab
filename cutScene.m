function [T_scene,sf] = cutScene...
    (vec_time,vec_score,windowSize,coeff_medfilt,filtertype,dsrate,is_plot)
% [T_scene,sf] = cutScene...
%   (vec_time,vec_score,windowSize,coeff_medfilt,filtertype,dsrate,is_plot)
% 場面の分岐点を検出し，場面を生成する関数
% 
% Input:
%	vec_time		: 時間ベクトル 
%	vec_param		: 特徴ベクトル
%   windowSize 		: 移動平均フィルタのタップ数
%   coeff_medfilt 	: メディアンフィルターの次数(filtertype=1のときは無視してよい)
%   filtertype		: 用いる移動平均フィルタの種類(1:basic 2:medSgolayfilter)
%   dsrate		 	: ダウンサンプリングレート
%   is_plot			: 結果をプロットするかどうか
% Output:
%   T_scene 		: 場面のテーブル
%   sf 				: フィルタを通過させたスコア

% 移動平均フィルタの適用
if filtertype == 1 % basic moving average
    sf = movingAverage(vec_score,windowSize);
elseif filtertype == 2 % sgolayfilter and medianfilter
    coeff_sgolayfilt = windowSize;
    sf = medSgolayfilt(vec_score,coeff_sgolayfilt,coeff_medfilt);
end

% 平滑化された信号のダウンサンプリング
% dsrate = 120; % ダウンサンプリングレート
sfds = downsample(sf,dsrate);

% ダウンサンプリングされた信号の極小値の抽出
[~,locs_valley_sfds] = getPeakValley(sfds,1,-Inf,-Inf,0,0,0);

% 得られた極小値から元のサンプリングレートでの位置をとり，場面を検出
usrate = dsrate; % アップサンプリングレート
sfrs = interp(sfds,usrate);
sfrs = sfrs(1:length(sf));
locs_valley_us = locs_valley_sfds * usrate - usrate;
scene_start(1) = vec_time(1);
scene_end(1) = vec_time(locs_valley_us(1));
if length(locs_valley_sfds)>1
    for i=2:length(locs_valley_sfds)
        scene_start(i) = vec_time(locs_valley_us(i-1));
        scene_end(i) = vec_time(locs_valley_us(i));
    end
    scene_start(i+1) = vec_time(locs_valley_us(i));
    scene_end(i+1) = vec_time(length(sf));
end

% テーブル作成
T_scene = table(scene_start',scene_end','VariableNames',...
    {'scene_start','scene_end'});

if is_plot==1
    t = linspace(vec_time(1),vec_time(end),length(vec_time));
    
    figure;
    plot(t,vec_score.*(mean(sfrs)/max(vec_score))); 
    hold all;
    plot(t,sfrs,'Color','g');
    stem(t(locs_valley_us),sfrs(locs_valley_us),'Color','r');
    hold off;
    title(['MovingAverageFrameLength= ',num2str(windowSize),' DownsamplingRate = ',num2str(dsrate)]);
    xlabel('Time [s]');
    ylabel('Score');
    %legend('Moving average','Downsample','Valley');
    xlim([t(1),t(end)]);
end

end
