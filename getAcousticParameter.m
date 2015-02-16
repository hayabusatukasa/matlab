function [vec_time,vec_param] = getAcousticParameter...
    (filename,s_start,s_end,deltaT,shiftT,fft_size,paramtype)
% �p�����[�^�擾�֐�
% Input:
%   filename    : �t�@�C����
%   s_start     : ���͂���ӏ��̊J�n����
%   s_end       : ���͂���ӏ��̏I�����ԁi�b�j
%   deltaT      : �t���[�����i�b�j
%   shiftT      : �t���[���V�t�g���i�b�j
%   fft_size    : FFT�T�C�Y�i2��2��{�j
%	paramtype 	: �����x�N�g���̎��(default=1)
%
% Output:
%   vec_time        : ���ԃx�N�g��
%   vec_param   : �����x�N�g��

if nargin<7
    paramtype=1;
end

%% �O����
audio_info = audioinfo(filename);
fs = audio_info.SampleRate;
readstart = round(s_start*fs+1);
readend = round(s_end*fs);
audio = audioread(filename, [readstart,readend]);
% �X�e���I�t�@�C�������m�����ɕϊ�
if audio_info.NumChannels > 1
    audio = (audio(:,1)+audio(:,2))/2;
end

fft_min = 0;        % �ŏ��̎��g��
fft_max = fs/2;    % �ő�̎��g��
I0 = 1e-12;          % ��̉��̋���

ma = miraudio(audio,fs);

%% �p�����[�^�擾
switch paramtype
%--- �����������x���ƃX�y�N�g���d�S ---
    case 1
        mfr = mirframe(ma,'Length',deltaT,'s','Hop',shiftT/deltaT);
        msp = mirspectrum(mfr,'Length',fft_size,'Min',fft_min,'Max',fft_max);
        
        % �����������x���̎擾
        fr = mirgetdata(mfr);
        mean_fr = mean(abs(fr),1)';
        Leq = 10*log10(mean_fr/I0);
        % mean_fr = mean(abs(fr),2);
        % L = 10*log10(mean_fr/P0);
        
        % �X�y�N�g���d�S�̎擾
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
        
        % �x�N�g����
        vec_param = [Leq,Cen];

%--- �t�B���^�o���N ---
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
        
%% ���Ԏ��̎擾
vec_time = s_start:shiftT:(s_end-deltaT);
vec_time = vec_time';

end
