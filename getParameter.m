function [time,L,cent] = getParameter...
    (filename_withoutWAV,s_start,s_end,deltaT,shiftT,fft_size)
% soundPickuper�X�N���v�g�ɂ�����p�����[�^�擾�֐�
% Input:
%   filename_withoutWAV : .wav�Ȃ��ł̃t�@�C����
%   s_start             : �w��̃t�@�C�����番�͂���ӏ��̊J�n���ԁi�b�j
%   s_end               : �w��̃t�@�C�����番�͂���ӏ��̏I�����ԁi�b�j
%   deltaT              : �t���[�����i�b�j
%   shiftT              : �t���[���V�t�g���i�b�j
%   fft_size            : FFT�T�C�Y�i2��2��{�j
%
% Output:
%   time                : �J�n���Ԃ���I�����Ԃ܂Ńt���[�����ŋ�؂�������
%   L                   : �����������x��
%   cent                : �X�y�N�g���d�S

%% �O����
filename_withWAV = [filename_withoutWAV,'.WAV'];
audio_info = audioinfo(filename_withWAV);
fs = audio_info.SampleRate;
readstart = round(s_start*fs+1);
readend = round(s_end*fs);
audio = audioread(filename_withWAV, [readstart,readend]);
if audio_info.NumChannels > 1
    audio = (audio(:,1)+audio(:,2))/2;
end

fft_min = 0;        % �ŏ��̎��g��
fft_max = fs/2;    % �ő�̎��g��
P0 = 2e-5;          % �����
%% �p�����[�^���o
ma = miraudio(audio,fs);
mfr = mirframe(ma,'Length',deltaT,'s','Hop',shiftT/deltaT);
msp = mirspectrum(mfr,'Length',fft_size,'Min',fft_min,'Max',fft_max);

% �����������x���̎擾
fr = mirgetdata(mfr)';
mean_fr = mean(fr.^2,2);
L = 10*log10(mean_fr/P0^2);

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
cent = numer./denom;

% ���Ԏ��̎擾
time = s_start:shiftT:(s_end-deltaT);
time = time';

end