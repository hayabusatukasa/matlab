clear all;
data = readtable('wdataver2_141105_001.csv');
range_time = length(data.Var1);
sec_pickup = 19;
num_pickup = 100;
t = data.Var1;
for i=1:length(t); time = cell2mat(t(i)); end
r = range_time-sec_pickup;
fs = 44100;

rng('shuffle');
for i=1:num_pickup
    R(i) = randi([1,r],1);
    score1(i) = sum(data.score1(R(i):(R(i)+sec_pickup)));
    score2(i) = sum(data.score2(R(i):(R(i)+sec_pickup)));
    R_time(i) = data.Var1(R(i));
end

for i=1:num_pickup
    tmp = cell2mat(R_time(i));
    time(i) = str2double(tmp);
    a_tmp = audioread('141105_001.wav',[fs*time(i)+1,fs*(time(i)+10)]);
    audio(i,:) = (a_tmp(:,1)+a_tmp(:,2))/2;
end