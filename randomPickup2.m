function str_random = randomPickup2(str_scene,num_pickup,sample_pickup)
% str_random = randomPickup2(str_scene,num_pickup,sample_pickup)
% 場面ごとの部分的箇所の取得
%
% Input:
%	str_scene	: 場面ごとのスコア
%	num_pickup	: ランダムな箇所を取り出す個数
%	sample_pickup: 取り出す箇所のサンプル長
%
% Output:
%	str_random	: ランダムに取り出した箇所

% 場面ごとに素材をランダムにピックアップし，それぞれの点数を出す
rng('shuffle');
for i=1:length(str_scene)
    s_start = str_scene(i).time(1);
    s_end = str_scene(i).time(end);
    % range_sample = length(str_scene(i).time)-sample_pickup;
    
    l = length(str_scene(i).score);
    if l >= sample_pickup
        n = num_pickup;
        range_sample = l-sample_pickup;
        
        % ランダムに素材となる部分の開始位置を指定数とる
        R = randi([1,range_sample],1,n);
        
        for j=1:n
            sum_score(j) = sum(str_scene(i).score(R(j):R(j)+sample_pickup));
            sum_start(j) = str_scene(i).time(R(j));
            sum_end(j)   = str_scene(i).time(R(j)+sample_pickup);
        end
    else
        sum_score = sum(str_scene(i).score);
        sum_start = str_scene(i).time(1);
        sum_end   = str_scene(i).time(end);
    end
        
    % 一時テーブルの作成と点数によるソート
    T_tmp = table(sum_score',sum_start',sum_end','VariableNames',...
        {'score','s_start','s_end'});
    T_tmp = sortrows(T_tmp,'score','descend');
    % 構造体に一時テーブルを格納
    str_random(i).table = T_tmp;
end
end
