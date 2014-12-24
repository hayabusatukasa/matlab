function d = getSceneDist(T_param,T_scene)

% パラメータを平均0，分散1に標準化
dB_sdz = standardization(T_param.dB);
cent_sdz = standardization(T_param.cent);

% 標準化したパラメータの場面ごとの平均と分散を取得
for i=1:height(T_scene)
    index_start = find(T_param.time==T_scene.scene_start(i));
    index_end = find(T_param.time==T_scene.scene_end(i));
    t_dB = dB_sdz(index_start:index_end);
    t_cent = cent_sdz(index_start:index_end);
    [~,dBq1,dBq2,dBq3,~] = quantile(t_dB);
    [~,centq1,centq2,centq3,~] = quantile(t_cent);
    sceneparam(i).dBq1 = dBq1;
    sceneparam(i).dBq2 = dBq2;
    sceneparam(i).dBq3 = dBq3;
    sceneparam(i).centq1 = centq1;
    sceneparam(i).centq2 = centq2;
    sceneparam(i).centq3 = centq3;
end

% 各パラメータの平均と分散の隣接する場面とのユークリッド距離を計算
for i=1:(length(sceneparam)-1)
    d(i) = dist(...
        [sceneparam(i).dBq1,sceneparam(i).dBq2,sceneparam(i).dBq3,...
        sceneparam(i).centq1,sceneparam(i).centq2,sceneparam(i).centq3],...
        [sceneparam(i+1).dBq1,sceneparam(i+1).dBq2,sceneparam(i+1).dBq3,...
        sceneparam(i+1).centq1,sceneparam(i+1).centq2,sceneparam(i+1).centq3]);
end
d = d';

end