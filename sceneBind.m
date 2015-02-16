function [T_scene,dw] = sceneBind(vec_time,vec_param,T_scene,thr_dist,wg_length)
% �e��ʂ̃p�����[�^�̋ߎ��x�����ʌ���������֐�
%
% Input:
%	vec_time	: ���ԃx�N�g��
%	vec_param	: �����x�N�g��
% 	T_scene 	: ��ʊJ�n�ƏI���e�[�u��
% 	thr_dist 	: ���������ʓ��m�̋����̂������l
% 	wg_length 	: ��ʂ̒����ɂ��d��
%
% Output:
% 	T_scene		: �V������ʃe�[�u��
%	dw			: ��ʊԂ̋���

if nargin<5
    wg_length = 60;
end
if nargin<4
    thr_dist = 1.0;
end

scstart = T_scene.scene_start;
scend = T_scene.scene_end;
% �d�݂Â���ꂽ�����̎擾
dw = getSceneDist(vec_time,vec_param,T_scene,wg_length);

while 1
    % �ł������̒Z����ʓ��m���擾
    dws = size(dw);
    if dws(1)>1
        [tmp,col] = min(dw);
        [~,row] = min(tmp);
        col = col(row);
        n = col;
    else
        [~,row] = min(dw);
        col = 1;
        n = 1;
    end
    
    if dw(col,row) <= thr_dist
        % ��ʂ̍X�V
        scstart(n) = scstart(n);
        scend(n) = scend(n+1);
        scstart = [scstart(1:n);scstart((n+2):end)];
        scend = [scend(1:n);scend((n+2):end)];
        
        % �e�[�u���̍X�V
        T_scene = table(scstart,scend,...
            'VariableNames',{'scene_start','scene_end'});
        scstart = T_scene.scene_start;
        scend = T_scene.scene_end;
        
        % �d�݂������̍X�V
        scenenum = height(T_scene);
        if scenenum==1
            % ��ʂ�1�ƂȂ����烋�[�v�𔲂���
            break;
        elseif n==1
            dwpart = getSceneDist(vec_time,vec_param,T_scene(1:2,:),wg_length);
            dw = [dwpart;dw(3:end,:)];
        elseif n==scenenum
            dwpart = getSceneDist(vec_time,vec_param,T_scene((end-1):end,:),wg_length);
            dw = [dw(1:(end-2),:);dwpart];
        else
            dwpart = getSceneDist(vec_time,vec_param,T_scene((n-1):(n+1),:),wg_length);
            dw = [dw(1:(n-2),:); dwpart; dw((n+2):end,:)];
        end
    else
        % ���ׂĂ̏d�݂����������ȏ�Ȃ烋�[�v�𔲂���
        break;   
    end 
end

end
