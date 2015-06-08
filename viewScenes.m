function viewScenes(vec_param,T_scene,pvdim)
% viewScenes(vec_param,T_scene)
% 場面をプロットする関数
%
% Input:
%	vec_param	: 特徴ベクトル
%	T_scene		: 場面テーブル
%   pvdim       : プロットするパラメータの数

t = linspace(0,T_scene.scene_end(end),length(vec_param));

[~,t_pvdim] = size(vec_param);
if nargin<3
    pvdim = t_pvdim;
elseif pvdim>t_pvdim || pvdim==0
    pvdim = t_pvdim;
end

if pvdim>4
    subp_h = 4;
    subp_w = ceil(pvdim/4);
else
    subp_h = pvdim;
    subp_w = 1;
end

figure;
for n=1:pvdim
    subplot(subp_h,subp_w,n);
    hold all;
    for i=1:height(T_scene)
        tmp = (t>=T_scene.scene_start(i))&(t<=T_scene.scene_end(i));
        h = plot(t(tmp),vec_param(tmp,n));
        h = get(h);
        tmp = tmp*mean(vec_param(tmp,n));
        plot(t,tmp,'Color',h.Color);
    end
    % stem(T_scene.scene_start,ones(1,length(T_scene.scene_start))*max(dB*10),...
    %     'LineStyle',':','Color','k');
    hold off;
    %title(['scene=', num2str(height(T_scene))]);
    xlim([0,T_scene.scene_end(end)]);
    ylim([min(vec_param(:,n)),max(vec_param(:,n))]);
    ylabel(['Param',num2str(n)]);
    xlabel('Time [s]');
end

end
