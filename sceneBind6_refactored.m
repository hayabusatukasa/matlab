function [T_scene,dw] = sceneBind6_refactored(T_param,T_scene,thr_dist,wg_length)
% [T,scene_start,scene_end] = sceneBind6(T_param,T_scene)
% 各場面のパラメータの近似度から場面結合をする関数
% ver 6.1 sceneBind6をまともな速度にリファクタリング
%
% Input:
% T_param : パラメータテーブル
% T_scene : 場面開始と終了テーブル
% thr_dist : 結合する場面同士の距離のしきい値
% wg_length : 場面の短さによる重み

if nargin<4
    wg_length = 60;
end
if nargin<3
    thr_dist = 1.0;
end

arg_scenelen = height(T_scene);
scstart = T_scene.scene_start;
scend = T_scene.scene_end;
% 重みづけられた距離の取得
dw = getSceneDist_Weighted(T_param,T_scene,wg_length);

while 1
    % 最も距離の短い場面同士を取得
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
        % 場面の更新
        scstart(n) = scstart(n);
        scend(n) = scend(n+1);
        scstart = [scstart(1:n);scstart((n+2):end)];
        scend = [scend(1:n);scend((n+2):end)];
        
        % テーブルの更新
        T_scene = table(scstart,scend,...
            'VariableNames',{'scene_start','scene_end'});
        scstart = T_scene.scene_start;
        scend = T_scene.scene_end;
        
        % 重みつき距離の更新
        scenenum = height(T_scene);
        if scenenum==1
            % 場面が1つとなったらループを抜ける
            break;
        elseif n==1
            dwpart = getSceneDist_Weighted(T_param,T_scene(1:2,:),wg_length);
            dw = [dwpart;dw(3:end,:)];
        elseif n==scenenum
            dwpart = getSceneDist_Weighted(T_param,T_scene((end-1):end,:),wg_length);
            dw = [dw(1:(end-2),:);dwpart];
        else
            dwpart = getSceneDist_Weighted(T_param,T_scene((n-1):(n+1),:),wg_length);
            dw = [dw(1:(n-2),:); dwpart; dw((n+2):end,:)];
        end
    else
        % すべての重みつき距離が一定以上ならループを抜ける
        break;   
    end 
end

end