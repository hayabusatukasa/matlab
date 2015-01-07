function [T_scene,dw] = sceneBind6(T_param,T_scene,thr_dist,wg_length)
% [T,scene_start,scene_end] = sceneBind6(T_param,T_scene)
% 各場面のパラメータの近似度から場面結合をする関数
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

% scenelen = T_scene.scene_end - T_scene.scene_start;
scstart = T_scene.scene_start;
scend = T_scene.scene_end;

while 1
    % 重みづけられた距離の取得
    dw = getSceneDist_Weighted(T_param,T_scene,wg_length);
    
    % 最も距離の短い場面同士を取得
    [tmp,col] = min(dw);
    [~,row] = min(tmp);
    col = col(row);
    n = col;
    
    if dw(col,row) <= thr_dist
        % 場面の更新
        scstart(n) = scstart(n);
        scend(n) = scend(n+1);
        scstart = [scstart(1:n);scstart((n+2):end)];
        scend = [scend(1:n);scend((n+2):end)];
        
        % テーブルを作成しなおして再度ループ処理
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

% 返値用のテーブル作成
T_scene = table(scstart,scend,'VariableNames',{'scene_start','scene_end'});

end