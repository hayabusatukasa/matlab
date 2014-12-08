load openloop60hertz
fs = 1000;
fsResamp = 1020;
spikeSignal = zeros(size(openLoopVoltage));
spikeSignal(1:100:2000) = -6;
noisyLoopVoltage = openLoopVoltage + spikeSignal;
medfiltLoopVoltage = medfilt1(noisyLoopVoltage,3);
vResamp = resample(medfiltLoopVoltage,fsResamp,fs);
tResamp = (0:numel(vResamp)-1) / fsResamp;
vAvgResamp = sgolayfilt(vResamp,1,17);
figure; plot(tResamp,vAvgResamp);
