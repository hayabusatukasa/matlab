function [T_scene,d] = sceneBind4(T_param,T_scene,thr_dist)
% [T,scene_start,scene_end] = sceneBind4(T_param,T_scene)
% 各場面のパラメータの近似度から場面結合をする関数
%
% Input:
% T_param : パラメータテーブル
% T_scene : 場面開始と終了テーブル
% thr_dist : 結合する場面同士の距離のしきい値

if nargin<3
    thr_dist = 1.0;
end

% 各場面の,隣接場面との距離を計算
d = getSceneDist(T_param,T_scene);

while isempty(find(d<thr_dist,1)) == 0
    
    % 距離の短い順にソート
    [d_sort,d_ix] = sort(d);
    
    t_st = T_scene.scene_start;
    t_en = T_scene.scene_end;
    scene_num = length(t_st);
    i = 1;
    % 距離の短い部分を，開始時間を一時的にNaNにして，結合する場面というラベルにする
    while d_sort(i) < thr_dist
        t_en(d_ix(i)) = t_en(d_ix(i)+1);
        t_st(d_ix(i)+1) = NaN;
        i=i+1;
    end
    
    % 場面の結合
    j=1;
    scene_start = [];
    scene_end = [];
    for i=1:scene_num
        if isnan(t_st(i))==0
            scene_start(j) = t_st(i);
            % 同じ処理を書いているのはインデックスのオーバーを防ぐため
            if i==scene_num
                scene_end(j) = t_en(i);
            elseif isnan(t_st(i+1))==0
                scene_end(j) = t_en(i);
                j=j+1;
            end
        else
            % 同じ処理を書いているのはインデックスのオーバーを防ぐため
            if i==scene_num
                scene_end(j) = t_en(i);
            elseif isnan(t_st(i+1))==0
                scene_end(j) = t_en(i);
                j=j+1;
            end
        end
    end
    
    % 返値用のテーブル作成
    T_scene = table(scene_start',scene_end','VariableNames',{'scene_start','scene_end'});
    d = getSceneDist(T_param,T_scene);
end

end