function T_scene = cutScene(time,score,thsld_score,windowSize,is_plot)

switch nargin
    case 2
        thsld_score = 20;
        windowSize = 10;
        is_plot = 0;
    case 3
        windowSize = 10;
        is_plot = 0;
    case 4
        is_plot = 0;
    otherwise
        
end
        
% 移動平均フィルタの適用
% windowSizeごとのフレームの平均をとる
coeff = ones(1,windowSize)/windowSize; 
score_filtered = filter(coeff,1,score);
score_filtered_upperthsld = ...
    score_filtered((windowSize+1):end) > thsld_score;

% cut scene
t = time((windowSize+1):end);
scene_start = 0;
scene_end = [];
scene_num = 1;
for i=2:length(t)
    idx = score_filtered_upperthsld(i);
    iidx = score_filtered_upperthsld(i-1);
    is_renew = iidx - idx;
    if is_renew == 1 % 1 to 0
        scene_end(scene_num) = t(i);
        scene_num = scene_num+1;
    elseif is_renew == -1 % 0 to 1
        scene_start(scene_num) = t(i);
    else % 0 to 0 / 1 to 1
        % nothing to do
    end
end
if length(scene_start) ~= length(scene_end)
    scene_end(scene_num) = t(end);
end

% make table
T_scene = table(scene_start',scene_end','VariableNames',...
    {'scene_start','scene_end'});

% plot score_filtered and threshold line
if is_plot==1
    figure;
    plot(t,score_filtered((windowSize+1):end)); hold all;...
        plot(t,linspace(thsld_score,thsld_score,length(t)));hold off;
    xlim([0,t(end)]);
end
end