function PQ = getParameterQuantile(T_param,T_scene)

scene_num = height(T_scene);

for i=1:scene_num
    idx = (T_param.time>=T_scene.scene_start(i))&(T_param.time<=T_scene.scene_end(i));
    
    t_L = T_param(idx,:).dB;
    t_C = T_param(idx,:).cent;
    [Lmin(i),Lq1(i),Lq2(i),Lq3(i),Lmax(i)] = quantile(t_L);
    [Cmin(i),Cq1(i),Cq2(i),Cq3(i),Cmax(i)] = quantile(t_C);
    
    t_start(i) = T_scene.scene_start(i);
    t_end(i) = T_scene.scene_end(i);
end

PQ = table(t_start',t_end',Lmin',Lq1',Lq2',Lq3',Lmax',Cmin',Cq1',Cq2',Cq3',Cmax',...
    'VariableNames',{'scene_start','scene_end',...
    'Lmin','Lq1','Lq2','Lq3','Lmax','Cmin','Cq1','Cq2','Cq3','Cmax'});

end