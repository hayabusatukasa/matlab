function dw = getSceneDist_Weighted(T_param,T_scene,wg_length)
% d = getSceneDist(T_param,T_scene)
% �e��ʂɂ��āC���̏�ʂƂ̋������v�Z����֐�

if height(T_scene)==1
    dw = Inf;
    return;
end

% �p�����[�^�𕽋�0�C���U1�ɕW����
dB_sdz = standardization(T_param.dB);
cent_sdz = standardization(T_param.cent);

% �W���������p�����[�^�̏�ʂ��Ƃ̕��ςƕ��U���擾
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

% �e�p�����[�^�̕��ςƕ��U�̗אڂ����ʂƂ̃��[�N���b�h�������v�Z
for i=1:(length(sceneparam)-1)
    d(i) = dist_euclidean(...
        [sceneparam(i).dBq1,sceneparam(i).dBq2,sceneparam(i).dBq3,...
        sceneparam(i).centq1,sceneparam(i).centq2,sceneparam(i).centq3],...
        [sceneparam(i+1).dBq1,sceneparam(i+1).dBq2,sceneparam(i+1).dBq3,...
        sceneparam(i+1).centq1,sceneparam(i+1).centq2,sceneparam(i+1).centq3]);
end

scenelen = T_scene.scene_end - T_scene.scene_start;
% �d�݂̎擾
w = getWeight(scenelen,wg_length);
for i=1:length(d)
    dw(i,:) = [d(i)*w(i) d(i)*w(i+1)];
end

end