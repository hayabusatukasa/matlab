function [T_scene,dw] = sceneBind(vec_time,vec_param,T_scene,thr_dist,wg_length)
% 各場面のパラメータの近似度から場面結合をする関数
%
% Input:
%	vec_time	: 時間ベクトル
%	vec_param	: 特徴ベクトル
% 	T_scene 	: 場面開始と終了テーブル
% 	thr_dist 	: 結合する場面同士の距離のしきい値
% 	wg_length 	: 場面の長さによる重み
%
% Output:
% 	T_scene		: 新しい場面テーブル
%	dw			: 場面間の距離

if nargin<5
    wg_length = 60;
end
if nargin<4
    thr_dist = 1.0;
end

scstart = T_scene.scene_start;
scend = T_scene.scene_end;
% 重みづけられた距離の取得
dw = getSceneDist(vec_time,vec_param,T_scene,wg_length);

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
        % すべての重みつき距離が一定以上ならループを抜ける
        break;   
    end 
end

end
