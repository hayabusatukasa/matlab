function [time,sp,L,cent,chro] = soundPickuper_getparameter...
    (filename_withoutWAV,s_start,s_end,deltaT,shiftT,fft_size)
% soundPickuperスクリプトにおけるパラメータ取得関数
% Input:
%   filename_withoutWAV : .wavなしでのファイル名
%   s_start             : 指定のファイルから分析する箇所の開始時間（秒）
%   s_end               : 指定のファイルから分析する箇所の終了時間（秒）
%   deltaT              : フレーム長（秒）
%   shiftT              : フレームシフト長（秒）
%   fft_size            : FFTサイズ（2の2乗倍）
%
% Output:
%   time                : 開始時間から終了時間までフレーム長で区切った時間
%   sp                  : フレームごとのスペクトル
%   L                   : 等価騒音レベル
%   cent                : スペクトル重心
%   chro                : クロマグラム

%% 前処理
filename_withWAV = [filename_withoutWAV,'.WAV'];
audio_info = audioinfo(filename_withWAV);
fs = audio_info.SampleRate;
readstart = round(s_start*fs+1);
readend = round(s_end*fs);
audio = audioread(filename_withWAV, [readstart,readend]);
if audio_info.NumChannels > 1
    audio = (audio(:,1)+audio(:,2))/2;
end

fft_min = 0;        % 最小の周波数
fft_max = 20000;    % 最大の周波数
P0 = 2e-5;          % 基準音圧
%% パラメータ抽出
ma = miraudio(audio,fs);
mfr = mirframe(ma,'Length',deltaT,'s','Hop',shiftT/deltaT);
msp = mirspectrum(mfr,'Length',fft_size,'Min',fft_min,'Max',fft_max);
mcent = mircentroid(msp,'MaxEntropy',1.0);
% mchro = mirchromagram(mfr);
fr = mirgetdata(mfr)';
mean_fr = mean(fr.^2,2);
L = 10*log10(mean_fr/P0^2);
sp = mirgetdata(msp)';
cent = mirgetdata(mcent)';
% chro = mirgetdata(mchro)';
chro = [];
time = s_start:shiftT:(s_end-deltaT);
time = time';



end







