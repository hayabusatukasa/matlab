function [time,rms,cent] = soundPickuper_getparameter...
    (filename_withoutWAV,s_start,s_end)
%% 前処理
filename_withWAV = [filename_withoutWAV,'.WAV'];
audio_info = audioinfo(filename_withWAV);
fs = audio_info.SampleRate;
audio = audioread(filename_withWAV, [s_start*fs+1,s_end*fs]);
if audio_info.NumChannels > 1
    audio = (audio(:,1)+audio(:,2))/2;
end

deltaT = 1.0;   % length of the signal in sec
shiftT = 0.5;   % shift length in sec
fft_size = 16384;
fft_min = 10;
fft_max = 15000;
%% パラメータ抽出
ma = miraudio(audio,fs);
fr = mirframe(ma,'Length',deltaT,'s','Hop',shiftT/deltaT);
msp = mirspectrum(fr,'Length',fft_size,'Min',fft_min,'Max',fft_max);
mcent = mircentroid(msp);
mrms = mirrms(fr);
sp = mirgetdata(msp)';
cent = sum(sp,2); 
rms = mirgetdata(mrms)';
time = s_start:shiftT:(s_end-1);
time = time';

end







