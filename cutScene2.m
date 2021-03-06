function [T_scene,score_filtered,thsld_hi,thsld_low] = cutScene2...
    (time,score,windowSize,coeff_medfilt,filtertype,is_scenebind,is_plot)
% ver2 閾値の自動決定

switch nargin
    case 2
        windowSize = 30;
        coeff_medfilt = 1;
        filtertype = 1;
        is_scenebind = 1;
        is_plot = 0;
    case 3
        coeff_medfilt = 1;
        filtertype = 1;
        is_scenebind = 1;
        is_plot = 0;
    case 4
        filtertype = 1;
        is_scenebind = 1;
        is_plot = 0;
    case 5
        is_scenebind = 1;
        is_plot = 0;
    case 6
        is_plot = 0;
    otherwise
        
end
        
% 移動平均フィルタの適用
if filtertype == 1 % basic moving average
    score_filtered = movingAverage(score,windowSize);
elseif filtertype == 2 % sgolayfilter and medianfilter
    coeff_sgolayfilt = windowSize;
    % coeff_medfilt = 5;
    score_filtered = medSgolayfilt(score,coeff_sgolayfilt,coeff_medfilt);
end

% 閾値の決定
[thsld_hi,thsld_low] = detectThreshold(score_filtered,200,0,0);

% 閾値判定の論理値ベクトルの生成
score_filtered_upperthsldlow = score_filtered > thsld_low;
score_filtered_lowerthsldhi =  score_filtered < thsld_hi;

% 場面切り出しループ
t = time;
scene_start = 0;
scene_end = [];
scene_num = 1;
len_scene_start = length(scene_start);
len_scene_end = length(scene_end);
for i=2:length(t)
    is_scene_end = score_filtered_upperthsldlow(i-1)...
                 - score_filtered_upperthsldlow(i); 
    is_scene_start = score_filtered_lowerthsldhi(i-1)...
                   - score_filtered_lowerthsldhi(i);
  
    if is_scene_end == 1
        % 場面の終わりが埋まってないとき埋める
        if len_scene_start ~= len_scene_end
            scene_end(scene_num) = t(i);
            scene_num = scene_num+1;
            len_scene_end = length(scene_end);
        end
    elseif is_scene_start == 1
        % 場面の始まりが決まってないとき埋める
        if len_scene_start == len_scene_end
            scene_start(scene_num) = t(i);
            len_scene_start = length(scene_start);
        end
    else
        % nothing to do
    end
end
if len_scene_start ~= len_scene_end
    scene_end(scene_num) = t(end);
end

% 短くとりすぎた場面を隣接する場面と結合する
if is_scenebind==1
    method = 1;
    thr = 200;
    [scene_start,scene_end,scene_num] = ...
        sceneBind(scene_start,scene_end,method,thr);
end

% make table
T_scene = table(scene_start',scene_end','VariableNames',...
    {'scene_start','scene_end'});

% plot score_filtered and threshold line
if is_plot==1
    figure;
    plot(t,score_filtered((windowSize+1):end)); hold all;...
        plot(t,linspace(thsld_low,thsld_low,length(t)));...
        plot(t,linspace(thsld_hi,thsld_hi,length(t))); hold off;
    xlim([0,t(end)]);
end
end