function T_scene = sceneBindForShortScene(T_scene,min_scene_len)
% T_scene = sceneBindForShortScene(T_scene,min_scenelen)
%
% �Z����ʂ�אڏ�ʂƌ�������֐�

scene_start = T_scene.scene_start;
scene_end = T_scene.scene_end;
scene_num = length(scene_start);
scene_len = scene_end - scene_start;

if scene_len == 1
    warning('It only has one scene! Return with doing nothing...');
    return;
end

while isequal(scene_len >= min_scene_len,ones(length(scene_len),1)) == 0
    
    % �ł��Z����ʂ̃C���f�b�N�X��������
    index = find(scene_len==min(scene_len));
    index = index(1);
    
    % �ł��Z����ʂ̗��ׂ̏�ʂ̒������擾
    if index == 1
        % index=1�̂Ƃ��͑O�̏�ʂ��Ȃ��̂Œ����𖳌���Ƃ��Ă���
        prescene_len = Inf; 
        nextscene_len = scene_len(index+1);
    elseif index == length(scene_len) 
        prescene_len = scene_end(index) - scene_start(index-1);
        % index=end�̂Ƃ��͎��̏�ʂ��Ȃ��̂Œ����𖳌���Ƃ��Ă���
        nextscene_len = Inf;
    else
        prescene_len = scene_len(index-1);
        nextscene_len = scene_len(index+1);
    end
    
    % ���ׂ̏�ʂ́C�Z���ق��Ɍ���
    if isinf(prescene_len)==1
        scene_start = scene_start((index+1):end);
        scene_end   = scene_end((index+1):end);
    elseif isinf(nextscene_len)==1
        scene_start = scene_start(1:(index-1));
        scene_end   = scene_end(1:(index-1));
    elseif prescene_len <= nextscene_len
        scene_end(index-1) = scene_end(index);
        scene_start = [scene_start(1:(index-1));scene_start((index+1):end)];
        scene_end   = [scene_end(1:(index-1));scene_end((index+1):end)];
    else
        scene_start(index+1) = scene_start(index);
        scene_start = [scene_start(1:(index-1));scene_start((index+1):end)];
        scene_end   = [scene_end(1:(index-1));scene_end((index+1):end)];
    end
    
    scene_num = scene_num - 1;
    scene_len = scene_end - scene_start;
    
end

T_scene = table(scene_start,scene_end,...
    'VariableNames',{'scene_start','scene_end'});

end