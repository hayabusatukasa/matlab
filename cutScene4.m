function [T_scene,sf,thsld_hi,thsld_low] = cutScene4...
    (T_param,windowSize,coeff_medfilt,filtertype,dsrate,is_scenebind,is_plot)
% 
%
% ver4 ダウンサンプリングを用いた閾値による決定
     
time = T_param.time;
score = T_param.score;

% 移動平均フィルタの適用
if filtertype == 1 % basic moving average
    sf = movingAverage(score,windowSize);
elseif filtertype == 2 % sgolayfilter and medianfilter
    coeff_sgolayfilt = windowSize;
    % coeff_medfilt = 5;
    sf = medSgolayfilt(score,coeff_sgolayfilt,coeff_medfilt);
end

% 平滑化された信号のダウンサンプリング
% dsrate = 120; % ダウンサンプリングレート
sfds = resample(sf,1,dsrate);

% 閾値の決定
[thsld_hi,thsld_low] = detectThreshold2(sfds,1,2,0,1);

% ダウンサンプリングした信号を元のサンプルリングレートに変換
sfrs = interp(sfds,dsrate);
sfrs = sfrs(1:length(sf));

% 閾値判定の論理値ベクトルの生成
sfrs_upperthsldlow = sfrs > thsld_low;
sfrs_lowerthsldhi =  sfrs < thsld_hi;

% 場面切り出しループ
t = time;
scene_start = 0;
scene_end = [];
scene_num = 1;
len_scene_start = length(scene_start);
len_scene_end = length(scene_end);
for i=2:length(t)
    is_scene_end = sfrs_upperthsldlow(i-1)...
                 - sfrs_upperthsldlow(i); 
    is_scene_start = sfrs_lowerthsldhi(i-1)...
                   - sfrs_lowerthsldhi(i);
  
    if is_scene_end == 1
        % 場面の終わりが埋まってないとき埋める
        if len_scene_start ~= len_scene_end
            scene_end(scene_num) = t(i);
            scene_num = scene_num+1;
            len_scene_end = length(scene_end);
        end
    elseif is_scene_start == 1
        % 場面の始まりが決まってないとき埋める
        if len_scene_start == len_scene_end
            scene_start(scene_num) = t(i);
            len_scene_start = length(scene_start);
        end
    else
        % nothing to do
    end
end
if len_scene_start ~= len_scene_end
    scene_end(scene_num) = t(end);
end

% テーブル作成
T_scene = table(scene_start',scene_end','VariableNames',...
    {'scene_start','scene_end'});

% 短くとりすぎた場面を隣接する場面と結合する
if is_scenebind==1
    T_scene = sceneBind3(T_param,T_scene,10);
end

if is_plot==1
    figure;
    plot(t,sf); hold all;
    plot(t,sfrs);
    plot(t,linspace(thsld_low,thsld_low,length(t)));
    plot(t,linspace(thsld_hi,thsld_hi,length(t))); hold off;
    xlim([0,t(end)]);
end
end