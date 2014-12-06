% dataT = readtable('T141105_001.csv');
thsld_score1 = 5;
thsld_score2 = 70;
windowSize  = 20;
for i=1:length(thsld_score1)
    [aT_scene,sf] = cutScene(T_param.time,T_param.score,...
        thsld_score1,thsld_score2,windowSize);
    len(i) = height(aT_scene);
end

t = T_param.time((windowSize+1):end);
tt = linspace(0,aT_scene.scene_end(end),aT_scene.scene_end(end)*2+1);
figure;
plot(t,sf((windowSize+1):end)); 
hold all;
plot(t,linspace(thsld_score1,thsld_score1,length(t)));
plot(t,linspace(thsld_score2,thsld_score2,length(t)));
for i=1:height(aT_scene)
    tmp = (tt>=aT_scene.scene_start(i))&(tt<=aT_scene.scene_end(i));
    tmp = tmp*mean([thsld_score1 thsld_score2]);
    plot(tt,tmp);
end
% label = dataT.label(1:length(tt));
% plot(tt,label);
% data = readtable('C:\Users\Shunji\Desktop\141121_002ƒƒ‚‘‚«.txt',...
%     'ReadVariableNames',false);

% ttt = linspace(0,1760,1760+1);
% for i=2:length(data.Var3)
%         label(i-1,:) = [zeros(1,data.Var3(i-1)),...
%             ones(1,(data.Var3(i)-data.Var3(i-1))),...
%             zeros(1,(1760-data.Var3(i)+1))];
% end
% plot(ttt,label*30);
hold off;
title(['filter-',num2str(windowSize)]);
xlim([0,T_param.time(end)]);
ylim([0,100]);
