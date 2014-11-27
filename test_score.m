clear all;
filename = '141111_001';
data = readtable(['wdataver3_',filename,'.csv']);
range_time = length(data.Var1);
sample_pickup = 33;
num_pickup = 1000;
t = data.Var1;
for i=1:length(t); time(i) = str2double(cell2mat(t(i))); end
r = range_time-sample_pickup;
fs = 44100;

% ランダムな範囲を指定数ピックアップ
rng('shuffle');
for i=1:num_pickup
    R(i) = randi([1,r],1);
    score1(i) = sum(data.score1(R(i):(R(i)+sample_pickup)));
    score2(i) = sum(data.score2(R(i):(R(i)+sample_pickup)));
    score3(i) = sum(data.score3(R(i):(R(i)+sample_pickup)));
    time_start(i) = time(R(i));
    time_end(i) = time(R(i)+sample_pickup)+1;
end
score_total = score1+score2+score3;
T = table(time_start',time_end',score1',score2',score3',score_total',...
    'VariableNames',{'t_start','t_end','score1','score2','score3','total'});
T = sortrows(T,'total','descend');

% ランダムに選ばれた範囲のデータ取得
for i=1:10
    a_tmp = audioread([filename,'.wav'],[fs*T.t_start(i)+1,fs*T.t_end(i)]);
    a_tmp = (a_tmp(:,1)+a_tmp(:,2))/2;
    audio(i,:) = a_tmp;
    
    % fadein and fadeout
    fade = 94500;   % in sample
    m = fade/fs;    % mean
    sd = m/2;       % standard varidation
    t = linspace(0,2*m,2*fade);
    a = -log(0.05)/sd;
    fadein = 1./(1+exp(-a*(t-m)));
    fadeout = 1./(1+exp(a*(t-m)));
    audio(i,1:(fade*2)) = audio(i,1:(fade*2)).*fadein;
    audio(i,(end-fade*2+1):end) = audio(i,(end-fade*2+1):end).*fadeout;
    
    % write audio
    s_tmp = int32(T.t_start(i));
    e_tmp = int32(T.t_end(i));
    wfname = ['\Users\Shunji\Music\RamdomPickup\','rank',num2str(i),...
        '_time',num2str(s_tmp),'-',num2str(e_tmp),'.wav'];
    audiowrite(wfname,audio(i,:),fs);
end

figure;
bar([T.score1 T.score2 T.score3],'stacked'); xlim([0 num_pickup+1]);
legend('score1','score2','score3');
