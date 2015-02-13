function [time,L,cent] = getParameter...
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
%   L                   : 等価騒音レベル
%   cent                : スペクトル重心

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
fft_max = fs/2;    % 最大の周波数
P0 = 2e-5;          % 基準音圧
%% パラメータ抽出
ma = miraudio(audio,fs);
mfr = mirframe(ma,'Length',deltaT,'s','Hop',shiftT/deltaT);
msp = mirspectrum(mfr,'Length',fft_size,'Min',fft_min,'Max',fft_max);

% 等価騒音レベルの取得
fr = mirgetdata(mfr)';
mean_fr = mean(fr.^2,2);
L = 10*log10(mean_fr/(P0^2));
% mean_fr = mean(abs(fr),2);
% L = 10*log10(mean_fr/P0);

% スペクトル重心の取得
sp = mirgetdata(msp)';
powersp = sp.^2;
fftunit = fs/fft_size;
tmp = 0:fftunit:(fs/2);
numer = zeros(length(powersp(:,1)),length(powersp(1,:)));
for i=1:length(powersp(:,1))
    numer(i,:) = powersp(i,:).*tmp;
end
numer = sum(numer,2);
denom = sum(powersp,2);
cent = numer./denom;

% 時間軸の取得
time = s_start:shiftT:(s_end-deltaT);
time = time';

end
