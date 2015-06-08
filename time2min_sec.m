function T_scene_minsec = time2min_sec(T_scene)

st = round(T_scene.scene_start);
se = round(T_scene.scene_end);
len = se-st;

sst(:,1) = floor(st./60);
sst(:,2) = mod(st,60);
sse(:,1) = floor(se./60);
sse(:,2) = mod(se,60);

T_scene_minsec = table(st,sst(:,1),sst(:,2),se,sse(:,1),sse(:,2),len,...
    'VariableNames',{'st','st_min','st_sec','se','se_min','se_sec','len'});

end