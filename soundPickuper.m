clear all;
%% 前処理
fname_withoutWAV = '141121_001';
filename = [fname_withoutWAV,'.WAV'];
a_info = audioinfo(filename);
fs = a_info.SampleRate;
i_stop = floor(a_info.Duration/60)-1;

%% フレームごとのパラメータ取得
t_total = cputime;
time = [];
sp = [];
rms = [];
cent = [];
chro = [];
deltaT = 0.2;
shiftT = 0.1;
for i=0:i_stop
    t_part = cputime;
    display(['calculating ',num2str(i),' to ',num2str(i+1)]);
    [t_time,t_sp,t_rms,t_cent,t_chro] = soundPickuper_getparameter...
        (fname_withoutWAV,i*60,(i+1)*60+shiftT);
    sp = cat(1,sp,t_sp);
    time = cat(1,time,t_time);
    rms = cat(1,rms,t_rms);
    cent = cat(1,cent,t_cent);
    chro = cat(1,chro,t_chro);
    t_part = cputime - t_part;
    display(['計算時間は ',num2str(t_part),' 秒です']);
end
t_total = cputime - t_total;
display(['トータルの計算時間は ',num2str(t_total),' 秒です']);

%% 点数計算
sec = 30/shiftT;   % スコア2の中央値と標準偏差をとるデータの間隔 in sample
med_rms = median(rms);
sd_rms = std(rms);
med_cent = median(cent);
sd_cent = std(cent);
for i=1:length(time)
    % スコア1の計算
    score1_rms(i) = detcurve(rms(i),med_rms,sd_rms);
    score1_cent(i) = detcurve(cent(i),med_cent,sd_cent);
    score1(i) = getscore(score1_rms(i),score1_cent(i));
    
    % スコア2の計算
    len = length(time);
    if i>sec && i<=(len-sec)
        tmp_rms = rms((i-sec):(i+sec));
        tmp_cent = cent((i-sec):(i+sec));
    elseif i<=sec && i<=(len-sec)
        tmp_rms = [rms(1:i);rms((i+1):(i+sec))];
        tmp_cent = [cent(1:i);cent((i+1):(i+sec))];
    elseif i>sec && i>(len-sec)
        tmp_rms = [rms((i-sec):(i-1));rms(i:len)];
        tmp_cent = [cent((i-sec):(i-1));cent(i:len)];
    end
    med_tmp_rms = median(tmp_rms);
    sd_tmp_rms = std(tmp_rms);
    med_tmp_cent = median(tmp_cent);
    sd_tmp_cent = std(tmp_cent);
    score2_rms(i) = detcurve(rms(i),med_tmp_rms,sd_tmp_rms);
    score2_cent(i)= detcurve(cent(i),med_tmp_cent,sd_tmp_cent);
    score2(i) = getscore(score2_rms(i),score2_cent(i));
end

%%  テーブル作成
T = table(time,rms,cent,score1',score2','VariableNames',...
    {'time','rms','cent','score1','score2'});
% T = sortrows(T,'total','descend');

%% プロット
% samplePerMin = 60/shiftT;
% coeff = ones(1,samplePerMin)/samplePerMin;
% sc1 = score1;
% sc2 = sc1+score2;
% score12 = (score1/100-score2/100).^2;
% sc1_filtered = filter(coeff,1,sc1);
% sc2_filtered = filter(coeff,1,sc2);
% score12_filtered = filter(coeff,1,score12);
% 
% t = linspace(time(1),time(end)/60,length(time));
% figure;
% subplot(2,1,1);
% plot(t,sc1_filtered,'DisplayName','sc1_filtered');hold all;...
%     plot(t,sc2_filtered,'DisplayName','sc2_filtered');hold off;
% xlim([0,time(end)/60]);
% subplot(2,1,2);
% plot(t,score12_filtered,'DisplayName','score12_filtered');
% xlim([0,time(end)/60]);

%% ランダムピックアップ
sample_pickup = int32(10/shiftT)-1;
num_pickup = 1000;
range_time = length(T.time);
r = range_time-sample_pickup;

rng('shuffle');
for i=1:num_pickup
    R(i) = randi([1,r],1);
    R_score1(i) = mean(T.score1(R(i):(R(i)+sample_pickup)));
    R_score2(i) = mean(T.score2(R(i):(R(i)+sample_pickup)));
    time_start(i) = time(R(i));
    time_end(i) = time(R(i)+sample_pickup)+shiftT;
end
score_total = R_score1+R_score2;
T_random = table(time_start',time_end',R_score1',R_score2',score_total',...
    'VariableNames',{'t_start','t_end','score1','score2','total'});
T_random = sortrows(T_random,'total','descend');

%% ピックアップされたオーディオの取得
for i=1:10
    readstart = round(T_random.t_start(i)*fs)+1;
    readend = round(T_random.t_end(i)*fs);
    a_tmp = audioread([fname_withoutWAV,'.wav'],[readstart,readend]);
    a_tmp = (a_tmp(:,1)+a_tmp(:,2))/2;
    audio(i,:) = a_tmp;
    
    % write audio
    s_tmp = int32(T_random.t_start(i));
    e_tmp = int32(T_random.t_end(i));
    wfname = ['\Users\Shunji\Music\RandomPickup_141121_001\','rank',num2str(i),...
        '_time',num2str(s_tmp),'-',num2str(e_tmp),'.wav'];
    audiowrite(wfname,audio(i,:),fs);
end
tmp = readstart-readend;