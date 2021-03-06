dB_sdz = standardization(T_param.dB);
cent_sdz = standardization(T_param.cent);

for i=1:height(aT_scene)
    index_start = find(T_param.time==aT_scene.scene_start(i));
    index_end = find(T_param.time==aT_scene.scene_end(i));
    t_dB = dB_sdz(index_start:index_end);
    t_cent = cent_sdz(index_start:index_end);
    sceneparam(i).dB = t_dB;
    sceneparam(i).cent = t_cent;
    sceneparam(i).st = aT_scene.scene_start(i);
    sceneparam(i).en = aT_scene.scene_end(i);
    sceneparam(i).len = length(t_dB);
    sceneparam(i).dBmean = mean(t_dB);
    sceneparam(i).centmean = mean(t_cent);
    sceneparam(i).dBstd = std(t_dB);
    sceneparam(i).centstd = std(t_cent);
end

for i=1:(length(sceneparam)-1)
    dist(i).st = i;
    dist(i).ed = i+1;
    dist(i).dBmean = sqrt((sceneparam(i).dBmean-sceneparam(i+1).dBmean)^2);
    dist(i).centmean = sqrt((sceneparam(i).centmean-sceneparam(i+1).centmean)^2);
    dist(i).dBstd = sqrt((sceneparam(i).dBstd-sceneparam(i+1).dBstd)^2);
    dist(i).centstd = sqrt((sceneparam(i).centstd-sceneparam(i+1).centstd)^2);
    dist(i).all = sqrt((sceneparam(i).dBmean-sceneparam(i+1).dBmean)^2+...
                       (sceneparam(i).centmean-sceneparam(i+1).centmean)^2+...
                       (sceneparam(i).dBstd-sceneparam(i+1).dBstd)^2+...
                       (sceneparam(i).centstd-sceneparam(i+1).centstd)^2);
                   
end

[dist_sort,dist_ix] = sort([dist.all]); 

t_st = aT_scene.scene_start;
t_en = aT_scene.scene_end;
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

T = table(scene_start',scene_end');


