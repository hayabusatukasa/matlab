load noisyecg.mat
t = 1:length(noisyECG_withTrend);

figure;
subplot(3,1,1);
plot(t,noisyECG_withTrend);
grid on;

% データのトレンド除去
[p,s,mu] = polyfit((1:numel(noisyECG_withTrend))',noisyECG_withTrend,10);
f_y = polyval(p,(1:numel(noisyECG_withTrend))',[],mu);

ECG_data = noisyECG_withTrend - f_y;

subplot(3,1,2);
plot(t,ECG_data); grid on;
ax = axis; axis([ax(1:2) -1.2 1.2]);
title('Detrended ECG Signal')

% 対象ピーク検出用閾値の設定
[~,locs_Rwave] = findpeaks(ECG_data,'MinPeakHeight',0.5,'MinPeakDistance',200);

% 信号の極小値の検出
ECG_inverted = -ECG_data;
[~,locs_Swave] = findpeaks(ECG_inverted,'MinPeakHeight',0.5,...
    'MinPeakDistance',200);

subplot(3,1,3);
hold on
plot(t,ECG_data);
plot(locs_Rwave,ECG_data(locs_Rwave),'rv','MarkerFaceColor','r');
plot(locs_Swave,ECG_data(locs_Swave),'rs','MarkerFaceColor','b');
axis([0 1850 -1.1 1.1]); grid on;
xlabel('Samples'); ylabel('Voltage(mV)');

                                