% % ver1
scene_start = [0 180 295 446 623 694 840 1017 1166 1293 1384 1564 1741 ...
    1861 2039 2218 2396 2590 2740 2854 3016 3137 3316 3496 3670];
scene_end =  [180 295 446 623 694 840 1017 1166 1293 1384 1564 1741 ...
    1861 2039 2218 2396 2590 2740 2854 3016 3137 3316 3496 3670 3764];
scenenum = 25;

% ver2
% scene_start = [0 115 293 444 571 748 896 1075 1146 1296 1474 1595 1773 ...
%     1967 2117 2297 2475 2654 2745 2926 3089 3179 3300 3477];
% scene_end = [0 115 293 444 571 748 896 1075 1146 1296 1474 1595 1773 ...
%     1967 2117 2297 2475 2654 2745 2926 3089 3179 3300 3593];
% scenenum = 24;

T_scene_trueposition = table(scene_start',scene_end',...
    'VariableNames',{'scene_start','scene_end'});
d_trueposition = [0; getSceneDist(T_param,T_scene_trueposition)];

T_scenenum25 = sceneBind3(T_param,T_scene,scenenum);

t = linspace(0,T_scene.scene_end(end),T_scene.scene_end(end)*2+1);
figure;

subplot(4,1,1);
hold all;
for i=1:height(T_scene10)
    tmp = (t>=T_scene10.scene_start(i))&(t<=T_scene10.scene_end(i));
    tmp = tmp*mean(d_trueposition);
    plot(t,tmp,'Color','b');
end
plot(t,ones(1,length(t)),'LineStyle','--','Color','r');
stem(scene_start,ones(1,length(scene_start))*100,'LineStyle',':','Color','k');
stem(scene_start,d_trueposition,'LineStyle','none','Color','r');
hold off;
title(['dist=1.0    scene=', num2str(height(T_scene10))]);
xlim([0,3764]);
ylim([0,max(d_trueposition)]);

subplot(4,1,2);
hold all;
for i=1:height(T_scene15)
    tmp = (t>=T_scene15.scene_start(i))&(t<=T_scene15.scene_end(i));
    tmp = tmp*mean(d_trueposition);
    plot(t,tmp,'Color','b');
end
plot(t,1.5*ones(1,length(t)),'LineStyle','--','Color','r');
stem(scene_start,ones(1,length(scene_start))*100,'LineStyle',':','Color','k');
stem(scene_start,d_trueposition,'LineStyle','none','Color','r');
hold off;
title(['dist=1.5    scene=', num2str(height(T_scene15))]);
xlim([0,3764]);
ylim([0,max(d_trueposition)]);

subplot(4,1,3);
hold all;
for i=1:height(T_scene20)
    tmp = (t>=T_scene20.scene_start(i))&(t<=T_scene20.scene_end(i));
    tmp = tmp*mean(d_trueposition);
    plot(t,tmp,'Color','b');
end
plot(t,2.0*ones(1,length(t)),'LineStyle','--','Color','r');
stem(scene_start,ones(1,length(scene_start))*100,'LineStyle',':','Color','k');
stem(scene_start,d_trueposition,'LineStyle','none','Color','r');
hold off;
title(['dist=2.0    scene=', num2str(height(T_scene20))]);
xlim([0,3764]);
ylim([0,max(d_trueposition)]);

subplot(4,1,4);
hold all;
for i=1:height(T_scenenum25)
    tmp = (t>=T_scenenum25.scene_start(i))&(t<=T_scenenum25.scene_end(i));
    tmp = tmp*mean(d_trueposition);
    plot(t,tmp,'Color','b');
end
stem(scene_start,ones(1,length(scene_start))*100,'LineStyle',':','Color','k');
stem(scene_start,d_trueposition,'LineStyle','none','Color','r');
hold off;
title(['scene=', num2str(height(T_scenenum25))]);
xlim([0,3764]);
ylim([0,max(d_trueposition)]);
xlabel('Time [s]');
