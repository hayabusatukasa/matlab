function D = getAllSceneDist(T_param,T_scene)
% D = getSceneAllDist(T_param,T_scene)
% �e��ʂɂ��āC���ׂĂ̏�ʂƂ̋������v�Z����֐�

if height(T_scene)==1
    D = Inf;
    return;
end

num_scene = height(T_scene);

% �p�����[�^�𕽋�0�C���U1�ɕW����
dB_sdz = standardization(T_param.dB);
cent_sdz = standardization(T_param.cent);

% �W���������p�����[�^�̏�ʂ��Ƃ̕��ςƕ��U���擾
for i=1:num_scene
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

% �����̌v�Z
D = zeros(num_scene,num_scene);
for k=1:num_scene
    for i=1:num_scene
        if k~=i
            D(k,i) = dist_euclidean(...
                [sceneparam(k).dBq1,sceneparam(k).dBq2,sceneparam(k).dBq3,...
                sceneparam(k).centq1,sceneparam(k).centq2,sceneparam(k).centq3],...
                [sceneparam(i).dBq1,sceneparam(i).dBq2,sceneparam(i).dBq3,...
                sceneparam(i).centq1,sceneparam(i).centq2,sceneparam(i).centq3]);
        else
            D(k,i) = Inf;
        end 
    end
end

end