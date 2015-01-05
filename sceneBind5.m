function [T_scene,d] = sceneBind5(T_param,T_scene,min_scene_num)
% [T,scene_start,scene_end] = sceneBind4(T_param,T_scene)
% �e��ʂ̃p�����[�^�̋ߎ��x�����ʌ���������֐�
%
% Input:
% T_param : �p�����[�^�e�[�u��
% T_scene : ��ʊJ�n�ƏI���e�[�u��
% thr_dist : ���������ʓ��m�̋����̂������l

if nargin<3
    scene_num = 10;
end

% �e��ʂ�,�אڏ�ʂƂ̋������v�Z
d = getSceneDist(T_param,T_scene);

while height(T_scene) > min_scene_num
    
    % �����̒Z�����Ƀ\�[�g
    [d_sort,d_ix] = sort(d);
    
    t_st = T_scene.scene_start;
    t_en = T_scene.scene_end;
    scene_num = length(t_st);
    % �ł������̒Z��������NaN�Ƃ���
    t_en(d_ix(1)) = t_en(d_ix(1)+1);
    t_st(d_ix(1)+1) = NaN;
    
    % ��ʂ̌���
    j=1;
    scene_start = [];
    scene_end = [];
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
    T_scene = table(scene_start',scene_end','VariableNames',{'scene_start','scene_end'});
    d = getSceneDist(T_param,T_scene);
end

end