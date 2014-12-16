
[a,fs] = audioread('test.wav');
fftsize = 2^15;
ma = miraudio(a(:,1),fs);
mfr = mirframe(ma,'Length',1.0,'s','Hop',0.5);
msp = mirspectrum(mfr,'Length',fftsize);
sp = mirgetdata(msp)';

fu = fs/fftsize;
for i=1:length(sp(1,:))
    tmp(i) = (i-1)*fu;
end

clear numer denom
for i=1:length(sp(:,1))
    numer(i,:) = sp(i,:).*tmp;
end
numer = sum(numer,2);
denom = sum(sp,2);
cent1 = numer./denom;

clear numer denom
psp = sp.^2;
for i=1:length(psp(:,1))
    numer(i,:) = psp(i,:).*tmp;
end
numer = sum(numer,2);
denom = sum(psp,2);
cent2 = numer./denom;

figure;
t = linspace(0,length(a(:,1))/fs,length(cent1));
subplot(2,1,1);
plot(t,cent1);
subplot(2,1,2);
plot(t,cent2);
