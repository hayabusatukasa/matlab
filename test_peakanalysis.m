load noisyecg.mat
t = 1:length(noisyECG_withTrend);

figure;
subplot(3,1,1);
plot(t,noisyECG_withTrend);
grid on;

% �f�[�^�̃g�����h����
[p,s,mu] = polyfit((1:numel(noisyECG_withTrend))',noisyECG_withTrend,10);
f_y = polyval(p,(1:numel(noisyECG_withTrend))',[],mu);

ECG_data = noisyECG_withTrend - f_y;

subplot(3,1,2);
plot(t,ECG_data); grid on;
ax = axis; axis([ax(1:2) -1.2 1.2]);
title('Detrended ECG Signal')

% �Ώۃs�[�N���o�p臒l�̐ݒ�
[~,locs_Rwave] = findpeaks(ECG_data,'MinPeakHeight',0.5,'MinPeakDistance',200);

% �M���̋ɏ��l�̌��o
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

                                