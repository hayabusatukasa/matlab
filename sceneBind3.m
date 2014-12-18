function [T,scene_start,scene_end] = sceneBind3(T_param,T_scene,min_scene_num)
% [T,scene_start,scene_end] = sceneBind2(T_param,T_scene)
% �e��ʂ̃p�����[�^�̋ߎ��x�����ʌ���������֐�
%
% Input:
% T_param : �p�����[�^�e�[�u��
% T_scene : ��ʊJ�n�ƏI���e�[�u��
% min_scene_num : �ŏ��V�[����

if nargin<3
    min_scene_num = 1;
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
    d(i) = dist(...
        [sceneparam(i).dBq1,sceneparam(i).dBq2,sceneparam(i).dBq3,...
        sceneparam(i).centq1,sceneparam(i).centq2,sceneparam(i).centq3],...
        [sceneparam(i+1).dBq1,sceneparam(i+1).dBq2,sceneparam(i+1).dBq3,...
        sceneparam(i+1).centq1,sceneparam(i+1).centq2,sceneparam(i+1).centq3]);
end

% �����̒Z�����Ƀ\�[�g
[d_sort,d_ix] = sort(d); 

t_st = T_scene.scene_start;
t_en = T_scene.scene_end;
scene_num = length(t_st);
i = 1;
% �����̒Z���������C�J�n���Ԃ��ꎞ�I��NaN�ɂ��āC���������ʂƂ������x���ɂ���
while (scene_num-i)>=min_scene_num
    t_en(d_ix(i)) = t_en(d_ix(i)+1);
    t_st(d_ix(i)+1) = NaN;
    i=i+1;
end

% ��ʂ̌���
j=1;
for i=1:scene_num
    if isnan(t_st(i))==0
        scene_start(j) = t_st(i);
        % ���������������Ă���̂̓C���f�b�N�X�̃I�[�o�[��h������
        if i==scene_num
            scene_end(j) = t_en(i);
        elseif isnan(t_st(i+1))==0
            scene_end(j) = t_en(i);
            j=j+1;
        end
    else
        % ���������������Ă���̂̓C���f�b�N�X�̃I�[�o�[��h������
        if i==scene_num
            scene_end(j) = t_en(i);
        elseif isnan(t_st(i+1))==0
            scene_end(j) = t_en(i);
            j=j+1;
        end
    end
end

% �Ԓl�p�̃e�[�u���쐬
T = table(scene_start',scene_end','VariableNames',{'scene_start','scene_end'});


end