clear all
filename = '141105_001';
data = readtable(['param30min_',filename,'.csv']);
tmp = data.Var1;
for i=1:length(tmp); time(i) = str2double(cell2mat(tmp(i))); end

%% filtering score
samplePerMin = 30;
coeff = ones(1,samplePerMin)/samplePerMin;

LN_me_filtered = filter(coeff,1,data.LN_me);
LN_sd_filtered = filter(coeff,1,data.LN_sd);
SP_me_filtered = filter(coeff,1,data.SP_me);
SP_sd_filtered = filter(coeff,1,data.SP_sd);
LN_me_filtered = LN_me_filtered((samplePerMin+1):end);
LN_sd_filtered = LN_sd_filtered((samplePerMin+1):end);
SP_me_filtered = SP_me_filtered((samplePerMin+1):end);
SP_sd_filtered = SP_sd_filtered((samplePerMin+1):end);

%% Plot
t = linspace(time(1),time(end)/60,length(time));
t = t((samplePerMin+1):end);
figure;
subplot(2,2,1);
plot(t,LN_me_filtered); title('LN_me'); xlim([0,time(end)/60]);
subplot(2,2,2);
plot(t,LN_sd_filtered); title('LN_sd'); xlim([0,time(end)/60]);
subplot(2,2,3);
plot(t,SP_me_filtered); title('SP_me'); xlim([0,time(end)/60]);
subplot(2,2,4);
plot(t,SP_sd_filtered); title('SP_sd'); xlim([0,time(end)/60]);