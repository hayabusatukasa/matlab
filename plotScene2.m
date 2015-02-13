function plotScene2(T_param,T_scene)

t = linspace(0,T_scene.scene_end(end),T_scene.scene_end(end)*2+1);

dB = T_param.dB;
cent = log(T_param.cent);

figure;
hold all;
for i=1:height(T_scene)
    tmp = (t>=T_scene.scene_start(i))&(t<=T_scene.scene_end(i));
    h = plot(t(tmp),dB(tmp),'Color','k');
    h = get(h);
    tmp = tmp*mean(dB(tmp));
    %plot(t,tmp,'Color',h.Color);
end
% stem(T_scene.scene_start,ones(1,length(T_scene.scene_start))*max(dB*10),...
%     'LineStyle',':','Color','k');
hold off;
title(['Loudness scene=', num2str(height(T_scene))]);
xlim([0,T_scene.scene_end(end)]);
ylim([min(dB),max(dB)]);
ylabel('Loudness [dB]');
xlabel('Time [s]');

figure;
hold all;
for i=1:height(T_scene)
    tmp = (t>=T_scene.scene_start(i))&(t<=T_scene.scene_end(i));
    h = plot(t(tmp),cent(tmp));
    h = get(h);
    tmp = tmp*mean(cent(tmp));
    plot(t,tmp,'Color',h.Color);
end
% stem(T_scene.scene_start,ones(1,length(T_scene.scene_start))*max(cent*10),...
%     'LineStyle',':','Color','k');
hold off;
title(['Sharpness scene=', num2str(height(T_scene))]);
xlim([0,T_scene.scene_end(end)]);
ylim([min(cent),max(cent)]);
ylabel('log(Sharpness)');
xlabel('Time [s]');

end
