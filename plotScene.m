function plotScene(T_param,T_scene)

t = linspace(0,T_scene.scene_end(end),T_scene.scene_end(end)*2+1);

figure;
subplot(2,1,1);
hold all;
for i=1:height(T_scene)
    tmp = (t>=T_scene.scene_start(i))&(t<=T_scene.scene_end(i));
    h = plot(t(tmp),T_param.dB(tmp));
    h = get(h);
    tmp = tmp*mean(T_param.dB(tmp));
    plot(t,tmp,'Color',h.Color);
end
% stem(T_scene.scene_start,ones(1,length(T_scene.scene_start))*max(T_param.dB*10),...
%     'LineStyle',':','Color','k');
hold off;
title(['Loudness scene=', num2str(height(T_scene))]);
xlim([0,T_scene.scene_end(end)]);
ylim([min(T_param.dB),max(T_param.dB)]);
ylabel('Loudness [dB]');
xlabel('Time [s]');

subplot(2,1,2);
hold all;
for i=1:height(T_scene)
    tmp = (t>=T_scene.scene_start(i))&(t<=T_scene.scene_end(i));
    h = plot(t(tmp),T_param.cent(tmp));
    h = get(h);
    tmp = tmp*mean(T_param.cent(tmp));
    plot(t,tmp,'Color',h.Color);
end
% stem(T_scene.scene_start,ones(1,length(T_scene.scene_start))*max(T_param.cent*10),...
%     'LineStyle',':','Color','k');
hold off;
title(['Sharpness scene=', num2str(height(T_scene))]);
xlim([0,T_scene.scene_end(end)]);
ylim([min(T_param.cent),max(T_param.cent)]);
ylabel('Sharpness');
xlabel('Time [s]');

end