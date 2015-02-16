function [vec_time,vec_param] = getAcousticParameter...
    (filename,s_start,s_end,deltaT,shiftT,fft_size,paramtype)
% パラメータ取得関数
% Input:
%   filename    : ファイル名
%   s_start     : 分析する箇所の開始時間
%   s_end       : 分析する箇所の終了時間（秒）
%   deltaT      : フレーム長（秒）
%   shiftT      : フレームシフト長（秒）
%   fft_size    : FFTサイズ（2の2乗倍）
%	paramtype 	: 特徴ベクトルの種類(default=1)
%
% Output:
%   vec_time        : 時間ベクトル
%   vec_param   : 特徴ベクトル

if nargin<7
    paramtype=1;
end

%% 前処理
audio_info = audioinfo(filename);
fs = audio_info.SampleRate;
readstart = round(s_start*fs+1);
readend = round(s_end*fs);
audio = audioread(filename, [readstart,readend]);
% ステレオファイルをモノラルに変換
if audio_info.NumChannels > 1
    audio = (audio(:,1)+audio(:,2))/2;
end

fft_min = 0;        % 最小の周波数
fft_max = fs/2;    % 最大の周波数
I0 = 1e-12;          % 基準の音の強さ

ma = miraudio(audio,fs);

%% パラメータ取得
switch paramtype
%--- 等価騒音レベルとスペクトル重心 ---
    case 1
        mfr = mirframe(ma,'Length',deltaT,'s','Hop',shiftT/deltaT);
        msp = mirspectrum(mfr,'Length',fft_size,'Min',fft_min,'Max',fft_max);
        
        % 等価騒音レベルの取得
        fr = mirgetdata(mfr);
        mean_fr = mean(abs(fr),1)';
        Leq = 10*log10(mean_fr/I0);
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
        Cen = numer./denom;
        
        % ベクトル化
        vec_param = [Leq,Cen];

%--- フィルタバンク ---
    case 2
        mfb = mirfilterbank(ma,'NbChannels',8);
        mfr = mirframe(mfb,'Length',deltaT,'s','Hop',shiftT/deltaT);
        fr = mirgetdata(mfr);
        N = size(fr);
        N = N(1,3);
        for n=1:N
            fb(:,n) = mean(abs(fr(:,:,n)),1)';
            Leq(:,n) = 10*log10(fb(:,n)/I0);
        end
        vec_param = Leq;
end
        
%% 時間軸の取得
vec_time = s_start:shiftT:(s_end-deltaT);
vec_time = vec_time';

end
