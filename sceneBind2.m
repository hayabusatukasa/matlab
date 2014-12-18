function [T,scene_start,scene_end] = sceneBind2(T_param,T_scene)
% [T,scene_start,scene_end] = sceneBind2(T_param,T_scene)
% 各場面のパラメータの近似度から場面結合をする関数

% パラメータを平均0，分散1に標準化
dB_sdz = standardization(T_param.dB);
cent_sdz = standardization(T_param.cent);

% 標準化したパラメータの場面ごとの平均と分散を取得
for i=1:height(T_scene)
    index_start = find(T_param.time==T_scene.scene_start(i));
    index_end = find(T_param.time==T_scene.scene_end(i));
    t_dB = dB_sdz(index_start:index_end);
    t_cent = cent_sdz(index_start:index_end);
    sceneparam(i).dBmean = mean(t_dB);
    sceneparam(i).centmean = mean(t_cent);
    sceneparam(i).dBvar = var(t_dB);
    sceneparam(i).centvar = var(t_cent);
end

% 各パラメータの平均と分散の隣接する場面とのユークリッド距離を計算
for i=1:(length(sceneparam)-1)
    dist(i) = sqrt(...
        (sceneparam(i).dBmean-sceneparam(i+1).dBmean)^2+...
        (sceneparam(i).centmean-sceneparam(i+1).centmean)^2+...
        (sceneparam(i).dBvar-sceneparam(i+1).dBvar)^2+...
        (sceneparam(i).centvar-sceneparam(i+1).centvar)^2);
end

[dist_sort,dist_ix] = sort(dist); 

t_st = T_scene.scene_start;
t_en = T_scene.scene_end;
scene_num = length(t_st);
i = 1;
while dist_sort(i) < 1.0
    t_en(dist_ix(i)) = t_en(dist_ix(i)+1);
    t_st(dist_ix(i)+1) = NaN;
    i=i+1;
end

j=1;
for i=1:scene_num
    if isnan(t_st(i))==0
        scene_start(j) = t_st(i);
        if i==scene_num
            scene_end(j) = t_en(i);
            j=j+1;
        elseif isnan(t_st(i+1))==0
            scene_end(j) = t_en(i);
            j=j+1;
        end
    else
        if i==scene_num
            scene_end(j) = t_en(i);
        elseif isnan(t_st(i+1))==0
            scene_end(j) = t_en(i);
            j=j+1;
        end
    end
end

T = table(scene_start',scene_end','VariableNames',{'scene_start','scene_end'});

end