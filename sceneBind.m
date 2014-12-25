function T = sceneBind(T_scene,method,thr)
% [scene_start,scene_end,scene_num] = ...
%    sceneBind(scene_start,scene_end,scene_num,thr_scenelength)
%
% 短くとりすぎた場面を一定の長さになるまで隣接の場面と結合
% 場面結合方法を，1場面の長さが一定以上になるか，
% 場面数が指定数に到達するまで結合する方法に指定可能
% Input:
% scene_start   : 場面開始位置列
% scene_end     : 場面終了位置列
% method        : 場面結合方法 (1:場面の長さ　2:場面数)
% thr           : 一場面の長さ，または場面数の指定

if nargin<3
    method = 1;
    thr = 200;
end

if nargin<4
    if method==1; thr = 200;
    elseif method==2; thr = 10;
    end
end

scene_start = T_scene.scene_start;
scene_end = T_scene.scene_end;
scene_num = length(scene_start);
scene_len = scene_end - scene_start;

if scene_len == 1
    warning('It only has one scene! Return with doing nothing...');
    return;
end

if method==1
    while isequal(scene_len >= thr,ones(1,length(scene_len))) == 0
    
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
elseif method==2
    while scene_num > thr
    
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
else
    warning('no such a method');
    return;
end

% 返値用のテーブル作成
T = table(scene_start',scene_end','VariableNames',{'scene_start','scene_end'});

end