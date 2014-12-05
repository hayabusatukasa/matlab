function [T_scene,score_filtered] = cutScene...
    (time,score,thsld_score1,thsld_score2,windowSize,is_plot)

switch nargin
    case 2
        thsld_score1 = 20;
        thsld_score2 = 50;
        windowSize = 10;
        is_plot = 0;
    case 3
        windowSize = 10;
        thsld_score2 = 50;
        is_plot = 0;
    case 4
        thsld_score2 = 50;
        is_plot = 0;
    case 5
        is_plot = 0;
    otherwise
        
end
        
% 移動平均フィルタの適用
% windowSizeごとのフレームの平均をとる
coeff = ones(1,windowSize)/windowSize; 
score_filtered = filter(coeff,1,score);

% 閾値判定の論理値ベクトルの生成
score_filtered_upperthsld1 = ...
    score_filtered((windowSize+1):end) > thsld_score1;
score_filtered_lowerthsld2 = ...
    score_filtered((windowSize+1):end) < thsld_score2;

% 場面切り出しループ
t = time((windowSize+1):end);
scene_start = 0;
scene_end = [];
scene_num = 1;
len_scene_start = length(scene_start);
len_scene_end = length(scene_end);
for i=2:length(t)   
    is_scene_end = ...
        score_filtered_upperthsld1(i-1) - score_filtered_upperthsld1(i); 
    is_scene_start = ...
        score_filtered_lowerthsld2(i-1) - score_filtered_lowerthsld2(i);
  
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

% make table
T_scene = table(scene_start',scene_end','VariableNames',...
    {'scene_start','scene_end'});

% plot score_filtered and threshold line
if is_plot==1
    figure;
    plot(t,score_filtered((windowSize+1):end)); hold all;...
        plot(t,linspace(thsld_score1,thsld_score1,length(t)));...
        plot(t,linspace(thsld_score2,thsld_score2,length(t))); hold off;
    xlim([0,t(end)]);
end
end