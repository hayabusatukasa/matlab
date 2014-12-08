function plotScene(T_param,T_scene,sf,thsld_low,thsld_hi,windowSize)
t = T_param.time((windowSize+1):end);
tt = linspace(0,T_scene.scene_end(end),T_scene.scene_end(end)*2+1);
figure;
plot(t,sf((windowSize+1):end)); 
hold all;
plot(t,linspace(thsld_low,thsld_low,length(t)),'LineStyle',':');
plot(t,linspace(thsld_hi,thsld_hi,length(t)),'LineStyle',':');
for i=1:height(T_scene)
    tmp = (tt>=T_scene.scene_start(i))&(tt<=T_scene.scene_end(i));
    tmp = tmp*mean([thsld_low thsld_hi]);
    plot(tt,tmp);
end
hold off;
title(['filter-',num2str(windowSize)]);
xlim([0,T_param.time(end)]);
ylim([0 100]);
end