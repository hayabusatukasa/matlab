%%
is_plot1 = 1;
is_plot2 = 0;

%% ver1
scene_start = [0 180 295 446 623 694 840 1017 1166 1293 1384 1564 1741 ...
    1861 2039 2218 2396 2590 2740 2854 3016 3137 3316 3496 3670];
scene_end =  [180 295 446 623 694 840 1017 1166 1293 1384 1564 1741 ...
    1861 2039 2218 2396 2590 2740 2854 3016 3137 3316 3496 3670 3764];
scenenum = 25;

T_scene_trueposition = table(scene_start',scene_end',...
    'VariableNames',{'scene_start','scene_end'});
d_trueposition = [0; getSceneDist(T_param,T_scene_trueposition)];

t = linspace(0,T_scene.scene_end(end),T_scene.scene_end(end)*2+1);

%%
dB = T_param.dB;
cent = log(T_param.cent);
wg_length = 100;
thr_dist = 1.0;
t_part = cputime;
display(['calculating T_scene1']);
T_scene1 = sceneBind6_refactored(T_param,T_scene,thr_dist,wg_length);
t_part = cputime - t_part;
display(['計算時間は ',num2str(t_part),' 秒です']);

thr_dist = 1.5;
t_part = cputime;
display(['calculating T_scene2']);
T_scene2 = sceneBind6_refactored(T_param,T_scene,thr_dist,wg_length);
t_part = cputime - t_part;
display(['計算時間は ',num2str(t_part),' 秒です']);

thr_dist = 2.0;
t_part = cputime;
display(['calculating T_scene3']);
T_scene3 = sceneBind6_refactored(T_param,T_scene,thr_dist,wg_length);
t_part = cputime - t_part;
display(['計算時間は ',num2str(t_part),' 秒です']);

%%
% centroid
subplot(3,1,1);
hold all;
for i=1:height(T_scene1)
    tmp = (t>=T_scene1.scene_start(i))&(t<=T_scene1.scene_end(i));
    h = plot(t(tmp),cent(tmp));
    h = get(h);
    tmp = tmp*mean(cent(tmp));
    plot(t,tmp,'Color',h.Color);
end
if is_plot1==1
h = stem(scene_start,ones(1,length(scene_start))*max(cent),...
    'LineStyle',':','Color','k','MarkerSize',0.1);
hleg = legend(h,'True position');
set(hleg,'Location','SouthEast');
end
if is_plot2==1
stem(T_scene1.scene_start,ones(1,length(T_scene1.scene_start))*max(cent*10),...
    'LineStyle',':','Color','k');
end
hold off;
title(['Sharpness dist=1.0 scene=', num2str(height(T_scene1))]);
xlim([0,T_scene.scene_end(end)]);
ylim([min(cent),max(cent)]);
ylabel('log(Sharpness)');
xlabel('Time [s]');

%%
% centroid
subplot(3,1,2);
hold all;
for i=1:height(T_scene2)
    tmp = (t>=T_scene2.scene_start(i))&(t<=T_scene2.scene_end(i));
    h = plot(t(tmp),cent(tmp));
    h = get(h);
    tmp = tmp*mean(cent(tmp));
    plot(t,tmp,'Color',h.Color);
end
if is_plot1==1
h = stem(scene_start,ones(1,length(scene_start))*max(cent),...
    'LineStyle',':','Color','k','MarkerSize',0.1);
hleg = legend(h,'True position');
set(hleg,'Location','SouthEast');
end
if is_plot2==1
stem(T_scene2.scene_start,ones(1,length(T_scene2.scene_start))*max(cent*10),...
    'LineStyle',':','Color','k');
end
hold off;
title(['Sharpness dist=1.5 scene=', num2str(height(T_scene2))]);
xlim([0,T_scene.scene_end(end)]);
ylim([min(cent),max(cent)]);
ylabel('log(Sharpness)');
xlabel('Time [s]');

%%
% centroid
subplot(3,1,3);
hold all;
for i=1:height(T_scene3)
    tmp = (t>=T_scene3.scene_start(i))&(t<=T_scene3.scene_end(i));
    h = plot(t(tmp),cent(tmp));
    h = get(h);
    tmp = tmp*mean(cent(tmp));
    plot(t,tmp,'Color',h.Color);
end
if is_plot1==1
h = stem(scene_start,ones(1,length(scene_start))*max(cent),...
    'LineStyle',':','Color','k','MarkerSize',0.1);
hleg = legend(h,'True position');
set(hleg,'Location','SouthEast');
end
if is_plot2==1
stem(T_scene3.scene_start,ones(1,length(T_scene3.scene_start))*max(cent*10),...
    'LineStyle',':','Color','k');
end
hold off;
title(['Sharpness dist=2.0 scene=', num2str(height(T_scene3))]);
xlim([0,T_scene.scene_end(end)]);
ylim([min(cent),max(cent)]);
ylabel('log(Sharpness)');
xlabel('Time [s]');
