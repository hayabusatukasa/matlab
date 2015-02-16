function dw = getSceneDist(vec_time,vec_param,T_scene,wg_length)
% dw = getSceneDist(vec_time,vec_param,T_scene,wg_length)
% 各場面について，次の場面との距離を計算する関数
% 短時間場面に対応するため，距離に重みづけを加えている
% 
% Input:
%	vec_time	: 時間ベクトル
%	vec_param	: 特徴ベクトル
%	T_scene		: 場面テーブル
%	wg_length	: 場面の長さにおける重み
%
% Output:
%	dw			: 重みづけされた距離

if height(T_scene)==1
    dw = [Inf Inf];
    return;
end

[~,pvdim] = size(vec_param);
num_scene = height(T_scene);

% パラメータを平均0，分散1に標準化
for n=1:pvdim
    pv_sdz(:,n) = standardization(vec_param(:,n));
end

% 標準化したパラメータの場面ごとの四分位点を取得
for i=1:num_scene
    index_start = find(vec_time==T_scene.scene_start(i));
    index_end = find(vec_time==T_scene.scene_end(i));
    t_pv = pv_sdz(index_start:index_end,:);
    for n=1:pvdim
        [~,q1(i,n),q2(i,n),q3(i,n),~] = quantile(t_pv(:,n));
    end
end

% 各パラメータの平均と分散の隣接する場面とのユークリッド距離を計算
for i=1:(num_scene-1)
    vec1=[]; vec2=[];
    for n=1:pvdim
        vec1 = [vec1,q1(i,n),q2(i,n),q3(i,n)];
        vec2 = [vec2,q1(i+1,n),q2(i+1,n),q3(i+1,n)];
    end
    d(i) = dist_euclidean(vec1,vec2);
end

scenelen = T_scene.scene_end - T_scene.scene_start;
% 重みの取得
w = getWeight(scenelen,wg_length);
for i=1:length(d)
    dw(i,:) = [d(i)*w(i) d(i)*w(i+1)];
end

end
