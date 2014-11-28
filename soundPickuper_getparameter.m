function [time,sp,db,cent,chro] = soundPickuper_getparameter...
    (filename_withoutWAV,s_start,s_end,deltaT,shiftT,fft_size)
%% 前処理
filename_withWAV = [filename_withoutWAV,'.WAV'];
audio_info = audioinfo(filename_withWAV);
fs = audio_info.SampleRate;
readstart = int32(s_start*fs+1);
readend = int32(s_end*fs);
audio = audioread(filename_withWAV, [readstart,readend]);
if audio_info.NumChannels > 1
    audio = (audio(:,1)+audio(:,2))/2;
end

% deltaT = 0.2;   % length of the signal in sec
% shiftT = 0.1;   % shift length in sec
% fft_size = 8192;
fft_min = 10;
fft_max = 15000;
P0 = 2e-5;
%% パラメータ抽出
ma = miraudio(audio,fs);
mfr = mirframe(ma,'Length',deltaT,'s','Hop',shiftT/deltaT);
msp = mirspectrum(mfr,'Length',fft_size,'Min',fft_min,'Max',fft_max);
mcent = mircentroid(msp,'MaxEntropy',1.0);
mchro = mirchromagram(mfr);
fr = mirgetdata(mfr)';
mean_power = mean(fr.^2,2);
db = 10*log10(mean_power/P0^2);
sp = mirgetdata(msp)';
cent = mirgetdata(mcent)';
chro = mirgetdata(mchro)';
time = s_start:shiftT:(s_end-deltaT);
time = time';

end







