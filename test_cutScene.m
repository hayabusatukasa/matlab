% dataT = readtable('T141105_001.csv');
windowSize  = 31;
coeff_medfilt = 10;
[aT_scene,sf,thsld_score2,thsld_score1] = ...
    cutScene2(T_param.time,T_param.score,windowSize,coeff_medfilt,2,1,0);
len(i) = height(aT_scene);

t = T_param.time((windowSize+1):end);
tt = linspace(0,aT_scene.scene_end(end),aT_scene.scene_end(end)*2+1);
figure;
plot(t,sf((windowSize+1):end)); 
hold all;
plot(t,linspace(thsld_score1,thsld_score1,length(t)),'LineStyle',':');
plot(t,linspace(thsld_score2,thsld_score2,length(t)),'LineStyle',':');
for i=1:height(aT_scene)
    tmp = (tt>=aT_scene.scene_start(i))&(tt<=aT_scene.scene_end(i));
    tmp = tmp*mean([thsld_score1 thsld_score2]);
    plot(tt,tmp);
end

data = readtable('C:\Users\Shunji\Desktop\141121_002ƒƒ‚‘‚«.txt',...
    'ReadVariableNames',false);

ttt = linspace(0,1760,1760+1);
for i=2:length(data.Var3)
        label(i-1,:) = [zeros(1,data.Var3(i-1)),...
            ones(1,(data.Var3(i)-data.Var3(i-1))),...
            zeros(1,(1760-data.Var3(i)+1))];
end
plot(ttt,label*10);

hold off;
title(['filter-',num2str(windowSize)]);
xlim([0,T_param.time(end)]);
ylim([0,max(sf)+5]);
