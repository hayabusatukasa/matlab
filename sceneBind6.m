function [T_scene,dw] = sceneBind6(T_param,T_scene,thr_dist,wg_length)
% [T,scene_start,scene_end] = sceneBind6(T_param,T_scene)
% �e��ʂ̃p�����[�^�̋ߎ��x�����ʌ���������֐�
%
% Input:
% T_param : �p�����[�^�e�[�u��
% T_scene : ��ʊJ�n�ƏI���e�[�u��
% thr_dist : ���������ʓ��m�̋����̂������l
% wg_length : ��ʂ̒Z���ɂ��d��

if nargin<4
    wg_length = 60;
end
if nargin<3
    thr_dist = 1.0;
end

% scenelen = T_scene.scene_end - T_scene.scene_start;
scstart = T_scene.scene_start;
scend = T_scene.scene_end;

while 1
    % �d�݂Â���ꂽ�����̎擾
    dw = getSceneDist_Weighted(T_param,T_scene,wg_length);
    
    % �ł������̒Z����ʓ��m���擾
    [tmp,col] = min(dw);
    [~,row] = min(tmp);
    col = col(row);
    n = col;
    
    if dw(col,row) <= thr_dist
        % ��ʂ̍X�V
        scstart(n) = scstart(n);
        scend(n) = scend(n+1);
        scstart = [scstart(1:n);scstart((n+2):end)];
        scend = [scend(1:n);scend((n+2):end)];
        
        % �e�[�u�����쐬���Ȃ����čēx���[�v����
        T_scene = table(scstart,scend,...
            'VariableNames',{'scene_start','scene_end'});
%         scenelen = T_scene.scene_end - T_scene.scene_start;
        scstart = T_scene.scene_start;
        scend = T_scene.scene_end;
        continue;
    else
        break;   
    end 
end

% �Ԓl�p�̃e�[�u���쐬
T_scene = table(scstart,scend,'VariableNames',{'scene_start','scene_end'});

end