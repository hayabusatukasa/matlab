clear all;
%% 前処理
fname_withoutWAV = '141111_001';
filename = [fname_withoutWAV,'.WAV'];
a_info = audioinfo(filename);
fs = a_info.SampleRate;
i_stop = floor(a_info.Duration/60)-1;

%% フレームごとのパラメータ取得
time = [];      % 時間
sp = [];        % スペクトル
db = [];        % dB (P0=20*10^-6)
cent = [];      % スペクトル重心
chro = [];      % クロマグラム
deltaT = 0.5;   % フレーム分解能
shiftT = 0.25;   % フレームシフト長
fft_size = 4096;% FFTサイズ
P0 = 2e-5;      % dB計算におけるP0

% パラメータ取得全体での計算時間の計測開始
t_total = cputime;
for i=0:i_stop
    % 1分ごとのパラメータ取得の計算時間の計測開始
    t_part = cputime;
    display(['calculating ',num2str(i),' to ',num2str(i+1)]);
    
    % パラメータ取得
    [t_time,t_sp,t_db,t_cent,t_chro] = soundPickuper_getparameter...
        (fname_withoutWAV,i*60,(i+1)*60+shiftT,deltaT,shiftT,fft_size);
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

%% 点数計算
% スコア2の中央値と標準偏差をとるデータの間隔 in sample
sec = 30/shiftT;    

% 一定以上のdBを持つインデックスのみを取り出す
thsld = 0.1;                       % threshold in amplitude
thsld_db = 10*log10(thsld^2/P0^2);  % in db
upperthsld = (db>=thsld_db);
db_upperthsld = db(upperthsld);
cent_upperthsld = cent(upperthsld);

% スコア1の計算に用いる，全体を見たときの中央値と標準偏差
med_db = median(db_upperthsld);
sd_db = std(db_upperthsld);
med_cent = median(cent_upperthsld);
sd_cent = std(cent_upperthsld);

for i=1:length(time)
    % スコア1の計算
    score1_db(i) = detcurve(db(i),med_db,sd_db);
    score1_cent(i) = detcurve(cent(i),med_cent,sd_cent);
    score1(i) = getscore(score1_db(i),score1_cent(i));
    
    % 現在のインデックスを中心として，一定区間をとる
    len = length(time);
    if i>sec && i<=(len-sec)
        tmp_db = db((i-sec):(i+sec));
        tmp_cent = cent((i-sec):(i+sec));
    elseif i<=sec && i<=(len-sec)
        tmp_db = [db(1:i);db((i+1):(i+sec))];
        tmp_cent = [cent(1:i);cent((i+1):(i+sec))];
    elseif i>sec && i>(len-sec)
        tmp_db = [db((i-sec):(i-1));db(i:len)];
        tmp_cent = [cent((i-sec):(i-1));cent(i:len)];
    end
    
    tmp_upperthsld = (tmp_db>=thsld_db);
    tmp_db = tmp_db(tmp_upperthsld);
    tmp_cent = tmp_cent(tmp_upperthsld);
    
    % 一定区間の中央値，標準偏差をとる
    if isempty(tmp_db)
        med_tmp_db = 0;
        sd_tmp_db = 0;
        med_tmp_cent = 0;
        sd_tmp_cent = 0;
    else
        med_tmp_db = median(tmp_db);
        sd_tmp_db = std(tmp_db);
        med_tmp_cent = median(tmp_cent);
        sd_tmp_cent = std(tmp_cent);
    end
    
    % スコア2の計算
    score2_db(i) = detcurve(db(i),med_tmp_db,sd_tmp_db);
    score2_cent(i)= detcurve(cent(i),med_tmp_cent,sd_tmp_cent);
    score2(i) = getscore(score2_db(i),score2_cent(i));
end

%%  テーブル作成
score_total = score1+score2;
T = table(time,db,cent,score1',score2',score_total','VariableNames',...
    {'time','dB','cent','score1','score2','total'});

% クロマトーンの取得
T_chro = table(time,chro(:,1),chro(:,2),chro(:,3),chro(:,4),chro(:,5),...
    chro(:,6),chro(:,7),chro(:,8),chro(:,9),chro(:,10),chro(:,11),chro(:,12),...
    'VariableNames',...
    {'time','C','Csharp','D','Dsharp','E','F','Fsharp','G','Gsharp','A','Asharp','B'});
thsld_chro = 0.999;
chromatone.C        = T_chro.time(T_chro.C>=thsld_chro);
chromatone.Csharp   = T_chro.time(T_chro.Csharp>=thsld_chro);
chromatone.D        = T_chro.time(T_chro.D>=thsld_chro);
chromatone.Dsharp   = T_chro.time(T_chro.Dsharp>=thsld_chro);
chromatone.E        = T_chro.time(T_chro.E>=thsld_chro);
chromatone.F        = T_chro.time(T_chro.F>=thsld_chro);
chromatone.Fsharp   = T_chro.time(T_chro.Fsharp>=thsld_chro);
chromatone.G        = T_chro.time(T_chro.G>=thsld_chro);
chromatone.Gsharp   = T_chro.time(T_chro.Gsharp>=thsld_chro);
chromatone.A        = T_chro.time(T_chro.A>=thsld_chro);
chromatone.Asharp   = T_chro.time(T_chro.Asharp>=thsld_chro);
chromatone.B        = T_chro.time(T_chro.B>=thsld_chro);

%% ランダムピックアップ
sample_pickup = int32(10/shiftT)-1;
num_pickup = 1000;
range_time = length(T.time);
r = range_time-sample_pickup;

rng('shuffle');
for i=1:num_pickup
    R(i) = randi([1,r],1);
    R_index = R(i):(R(i)+sample_pickup);
    R_score1(i) = mean(score1(R(i):(R(i)+sample_pickup)));
    R_score2(i) = mean(score2(R(i):(R(i)+sample_pickup)));
    time_start(i) = T.time(R(i));
    time_end(i) = T.time(R(i)+sample_pickup)+shiftT;
end
R_score_total = R_score1+R_score2;
T_random = table(time_start',time_end',R_score1',R_score2',R_score_total',...
    'VariableNames',{'t_start','t_end','score1','score2','total'});
T_random = sortrows(T_random,'total','descend');

%% ピックアップされたオーディオの取得
% for i=1:10
%     readstart = round(T_random.t_start(i)*fs)+1;
%     readend = round(T_random.t_end(i)*fs);
%     a_tmp = audioread([fname_withoutWAV,'.wav'],[readstart,readend]);
%     a_tmp = (a_tmp(:,1)+a_tmp(:,2))/2;
%     audio(i,:) = a_tmp;
%     
%     % write audio
%     s_tmp = int32(T_random.t_start(i));
%     e_tmp = int32(T_random.t_end(i));
%     wfname = ['\Users\Shunji\Music\RandomPickup_141121_001\',...
%        'rank',num2str(i),'_time',num2str(s_tmp),'-',num2str(e_tmp),'.wav'];
%     audiowrite(wfname,audio(i,:),fs);
% end
% 
% T_sort = sortrows(T,'total','descend');
% goodaudio = [];
% fade = 5;
% m = fade/fs;    % mean
% sd = m/2;       % standard varidation
% t = linspace(0,2*m,2*fade);
% a = -log(0.05)/sd;
% fadein = 1./(1+exp(-a*(t-m)));
% fadeout = 1./(1+exp(a*(t-m)));
% for i=1:1000
%     readstart = round(T_sort.time(i)*fs)+1;
%     readend = round((T_sort.time(i)+deltaT)*fs);
%     a_tmp = audioread([fname_withoutWAV,'.wav'],[readstart,readend]);
%     a_tmp = (a_tmp(:,1)+a_tmp(:,2))/2;
%  
%     a_tmp(1:(fade*2)) = a_tmp(1:(fade*2)).*fadein';
%     a_tmp((end-fade*2+1):end) = a_tmp((end-fade*2+1):end).*fadeout';
%     
%     goodaudio = cat(1,goodaudio,a_tmp);
% end
% wfname = ['\Users\Shunji\Music\RandomPickup_141121_001\','goodaudio','.wav'];
% audiowrite(wfname,goodaudio,fs);
