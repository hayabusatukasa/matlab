clear all
filename = '141121_001';
data = readtable(['wdataver3_',filename,'.csv']);
tmp = data.Var1;
for i=1:length(tmp); time(i) = str2double(cell2mat(tmp(i))); end

%% filtering score
samplePerMin = 120;
coeff = ones(1,samplePerMin)/samplePerMin;

score12 = (data.score2-data.score1)/100;
score23 = (data.score3-data.score2)/100;
score31 = (data.score1-data.score3)/100;
score12_power = score12.*score12;
score23_power = score23.*score23;
score31_power = score31.*score31;
score12_filtered = filter(coeff,1,score12_power);
score23_filtered = filter(coeff,1,score23_power);
score31_filtered = filter(coeff,1,score31_power);

sc1 = data.score1;
sc2 = sc1+data.score2;
sc3 = sc2+data.score3;
sc1_filtered = filter(coeff,1,sc1);
sc2_filtered = filter(coeff,1,sc2);
sc3_filtered = filter(coeff,1,sc3);

%% Plot
t = linspace(time(1),time(end)/60,length(time));
figure;
subplot(2,1,1);
plot(t,score12_filtered,'DisplayName','score12_filtered');hold all;...
    plot(t,score23_filtered,'DisplayName','score23_filtered');...
    plot(t,score31_filtered,'DisplayName','score31_filtered');hold off;
xlim([0,time(end)/60]);
% legend('score12','score23','score31','Location','EastOutside');
subplot(2,1,2);
plot(t,sc1_filtered,'DisplayName','sc1_filtered');hold all;...
    plot(t,sc2_filtered,'DisplayName','sc2_filtered');...
    plot(t,sc3_filtered,'DisplayName','sc3_filtered');hold off;
xlim([0,time(end)/60]);
% legend('score1 ','score12','scor123','Location','EastOutside');