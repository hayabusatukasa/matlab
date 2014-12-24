function [T_scene,d] = sceneBind4(T_param,T_scene,thr_dist)
% [T,scene_start,scene_end] = sceneBind4(T_param,T_scene)
% �e��ʂ̃p�����[�^�̋ߎ��x�����ʌ���������֐�
%
% Input:
% T_param : �p�����[�^�e�[�u��
% T_scene : ��ʊJ�n�ƏI���e�[�u��
% thr_dist : ���������ʓ��m�̋����̂������l

if nargin<3
    thr_dist = 1.0;
end

% �e��ʂ�,�אڏ�ʂƂ̋������v�Z
d = getSceneDist(T_param,T_scene);

while isempty(find(d<thr_dist,1)) == 0
    
    % �����̒Z�����Ƀ\�[�g
    [d_sort,d_ix] = sort(d);
    
    t_st = T_scene.scene_start;
    t_en = T_scene.scene_end;
    scene_num = length(t_st);
    i = 1;
    % �����̒Z���������C�J�n���Ԃ��ꎞ�I��NaN�ɂ��āC���������ʂƂ������x���ɂ���
    while d_sort(i) < thr_dist
        t_en(d_ix(i)) = t_en(d_ix(i)+1);
        t_st(d_ix(i)+1) = NaN;
        i=i+1;
    end
    
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