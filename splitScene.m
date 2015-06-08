function T_scene = splitScene(vec_time,num_split)

time = vec_time;
len_time = length(time);

scene_start = [];
scene_end = [];

n=1;
for i=1:num_split:(len_time-num_split)
    scene_start(n) = time(i);
    scene_end(n)   = time(i+num_split);
    n=n+1;
end

T_scene = table(scene_start',scene_end',...
    'VariableNames',{'scene_start','scene_end'});

end