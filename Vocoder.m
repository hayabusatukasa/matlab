function yule = Vocoder(a_in,mel_in,fs,ao_sec)

gain1 = 1.0;
gain2 = 1.0;

yu = a_in(1:fs*ao_sec,1).*gain1;
le = mel_in(1:fs*ao_sec,1).*gain2;
len = length(yu);
% whn = 2*rand(len,1)-1;
% le = whn;
% プリエンファシス
yu = filter([1, -0.97],1,yu);

fftsize = 1024;
fftshift = fftsize/2;
N = floor(len/fftshift);
N = N -1;
window = hann(fftsize)';

%%
% ma = miraudio(yu_orig,fs);
% mfr = mirframe(ma,'Length',fftsize,'sp','Hop',fftshift/fftsize);
% mroll = mirrolloff(mfr,'Threshold',.95);

%%
yu_fft = zeros(N,fftsize);
le_fft = zeros(N,fftsize);
for i=1:N
    yu_frame = yu(((i-1)*fftshift+1):((i-1)*fftshift+fftsize));
    le_frame = le(((i-1)*fftshift+1):((i-1)*fftshift+fftsize));
    yu_fft(i,:) = fft(yu_frame'.*window);
    le_fft(i,:) = fft(le_frame'.*window);
end

%%
% cross_fft = le_fft.*abs(yu_fft);
rho = abs(yu_fft).*abs(le_fft);
theta = atan2(imag(le_fft),real(le_fft));
[X,Y] = pol2cart(theta,rho);
cross_fft = X+Y*1i;

%%
cross = zeros(N,fftsize);
for i=1:N
    cross(i,:) = ifft(cross_fft(i,:));
end
cross = real(cross);

%%
yule = zeros(1,N*fftshift);
yule(1:fftsize) = cross(1,:);
for i=2:N
    wav1 = cross(i-1,:).*window;
    wav2 = cross(i,:).*window;
    wavcross = wav1((fftshift+1):end)+wav2(1:fftshift);
    yule(((i-1)*fftshift+1):((i-1)*fftshift+fftshift)) = wavcross;
end
yule = filter([1, 0.97],1,yule);
yule = .95.*yule./max(abs(yule));

end