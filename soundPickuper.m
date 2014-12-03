clear all;
%% 前処理
fname_withoutWAV = '141121_001';
filename = [fname_withoutWAV,'.WAV'];
a_info = audioinfo(filename);
fs = a_info.SampleRate;
dur = a_info.Duration;
i_stop = ceil(dur/60)-1;

%% フレームごとのパラメータ取得
time = [];      % 時間
sp = [];        % スペクトル
db = [];        % dB (P0=20*10^-6)
cent = [];      % スペクトル重心
chro = [];      % クロマグラム
deltaT = 1.0;   % フレーム分解能
shiftT = 0.5;   % フレームシフト長
fft_size = 2^15;% FFTサイズ
P0 = 2e-5;      % dB計算におけるP0

% パラメータ取得全体での計算時間の計測開始
t_total = cputime;
for i=0:i_stop
    % 1分ごとのパラメータ取得の計算時間の計測開始
    t_part = cputime;
    display(['calculating ',num2str(i),' to ',num2str(i+1)]);

    % 60秒ごとにパラメータ取得関数に入るが，末尾でオーバーしないようにする
    if (dur-i*60)<60
        interval = floor(dur)-i*60;
        s_start = i*60;
        s_end = s_start+interval;
    else
        s_start = i*60;
        s_end = (i+1)*60+shiftT;
    end
    
    % パラメータ取得し，一時変数に格納
    [t_time,t_sp,t_db,t_cent,t_chro] = soundPickuper_getparameter...
        (fname_withoutWAV,s_start,s_end,deltaT,shiftT,fft_size);
    
    % 一時変数を結合
    sp = cat(1,sp,t_sp);
    time = cat(1,time,t_time);
    db = cat(1,db,t_db);
    cent = cat(1,cent,t_cent);
    chro = cat(1,chro,t_chro);
    
    % 1分ごとのパラメータ取得の計算時間の計測終了
    t_part = cputime - t_part;
    display(['計算時間は ',num2str(t_part),' 秒です']);
end
% パラメータ取得全体での計算時間の計測終了
t_total = cputime - t_total;
display(['トータルの計算時間は ',num2str(t_total),' 秒です']);

clear t_time t_sp t_db t_cent t_chro t_part t_total s_start s_end;

%% 点数計算
[score1,score2] = calcScore(time,db,cent,shiftT);

%%  テーブル作成
score_total = score1+score2;
T = table(time,db,cent,score1',score2',score_total','VariableNames',...
    {'time','dB','cent','score1','score2','total'});
% T2 = table(time,db,cent,array_med_db',array_sd_db',array_med_cent',array_sd_cent',...
%     'VariableNames',{'time','db','cent','med_db','sd_db','med_cent','sd_cent'});
writetable(T,['T_',fname_withoutWAV,'.csv']);
% writetable(T2,['T2_',fname_withoutWAV,'.csv']);

clear time dB cent score1 score2 total;

%% 場面の切り出し
thsld_score = 20;
windowSize = 10;
T_scene = cutScene(T.time,T.score2,thsld_score,windowSize);

%% ランダムピックアップ
% sample_pickup = round(10/shiftT)-1;
% num_pickup = 1000;
% range_time = length(T.time);
% r = range_time-sample_pickup;
% 
% rng('shuffle');
% for i=1:num_pickup
%     R(i) = randi([1,r],1);
%     R_index = R(i):(R(i)+sample_pickup);
%     R_score1(i) = mean(score1(R(i):(R(i)+sample_pickup)));
%     R_score2(i) = mean(score2(R(i):(R(i)+sample_pickup)));
%     time_start(i) = T.time(R(i));
%     time_end(i) = T.time(R(i)+sample_pickup)+shiftT;
% end
% R_score_total = R_score1+R_score2;
% T_random = table(time_start',time_end',R_score1',R_score2',R_score_total',...
%     'VariableNames',{'t_start','t_end','score1','score2','total'});
% T_random = sortrows(T_random,'total','descend');

