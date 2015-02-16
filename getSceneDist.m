function dw = getSceneDist(vec_time,vec_param,T_scene,wg_length)
% dw = getSceneDist(vec_time,vec_param,T_scene,wg_length)
% �e��ʂɂ��āC���̏�ʂƂ̋������v�Z����֐�
% �Z���ԏ�ʂɑΉ����邽�߁C�����ɏd�݂Â��������Ă���
% 
% Input:
%	vec_time	: ���ԃx�N�g��
%	vec_param	: �����x�N�g��
%	T_scene		: ��ʃe�[�u��
%	wg_length	: ��ʂ̒����ɂ�����d��
%
% Output:
%	dw			: �d�݂Â����ꂽ����

if height(T_scene)==1
    dw = [Inf Inf];
    return;
end

[~,pvdim] = size(vec_param);
num_scene = height(T_scene);

% �p�����[�^�𕽋�0�C���U1�ɕW����
for n=1:pvdim
    pv_sdz(:,n) = standardization(vec_param(:,n));
end

% �W���������p�����[�^�̏�ʂ��Ƃ̎l���ʓ_���擾
for i=1:num_scene
    index_start = find(vec_time==T_scene.scene_start(i));
    index_end = find(vec_time==T_scene.scene_end(i));
    t_pv = pv_sdz(index_start:index_end,:);
    for n=1:pvdim
        [~,q1(i,n),q2(i,n),q3(i,n),~] = quantile(t_pv(:,n));
    end
end

% �e�p�����[�^�̕��ςƕ��U�̗אڂ����ʂƂ̃��[�N���b�h�������v�Z
for i=1:(num_scene-1)
    vec1=[]; vec2=[];
    for n=1:pvdim
        vec1 = [vec1,q1(i,n),q2(i,n),q3(i,n)];
        vec2 = [vec2,q1(i+1,n),q2(i+1,n),q3(i+1,n)];
    end
    d(i) = dist_euclidean(vec1,vec2);
end

scenelen = T_scene.scene_end - T_scene.scene_start;
% �d�݂̎擾
w = getWeight(scenelen,wg_length);
for i=1:length(d)
    dw(i,:) = [d(i)*w(i) d(i)*w(i+1)];
end

end
