function [scene_start,scene_end,scene_num] = ...
    sceneBind(scene_start,scene_end,scene_num,thr_scenelength)
% ’Z‚­‚Æ‚è‚·‚¬‚½ê–Ê‚ðˆê’è‚Ì’·‚³‚É‚È‚é‚Ü‚Å—×Ú‚Ìê–Ê‚ÆŒ‹‡

scene_len = scene_end - scene_start;

if scene_len == 1
    warning('it only has one scene');
    return;
end

while isequal(scene_len >= thr_scenelength,ones(1,length(scene_len))) == 0
    
    index = find(scene_len==min(scene_len));
    index = index(1);
    
    if index == 1
        prescene = Inf;
        nextscene = scene_start(index+1) - scene_end(index);
    elseif index == length(scene_len)
        prescene = scene_end(index) - scene_start(index-1);
        nextscene = Inf;
    else
        prescene = scene_end(index) - scene_start(index-1);
        nextscene = scene_start(index+1) - scene_end(index);
    end
    
    if prescene <= nextscene
        scene_end(index-1) = scene_end(index);
        scene_start = [scene_start(1:(index-1)),scene_start((index+1):end)];
        scene_end = [scene_end(1:(index-1)),scene_end((index+1):end)];
    elseif nextscene < prescene
        scene_start(index+1) = scene_start(index);
        scene_start = [scene_start(1:(index-1)),scene_start((index+1):end)];
        scene_end = [scene_end(1:(index-1)),scene_end((index+1):end)];
    end
    scene_num = scene_num - 1;
    scene_len = scene_end - scene_start;
end

end