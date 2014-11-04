% function ohoge(filename,s_start,s_end)
audio_info = audioinfo(filename);
fs = audio_info.SampleRate;
audio = audioread(filename, [s_start*fs+1,s_end*fs]);
if audio_info.NumChannels > 1
    audio = (audio(:,1)+audio(:,2))/2;
end

mstruct = mirstruct;
mstruct.tmp.a = miraudio(0,1);
ma = miraudio(audio,fs);
mstruct.ma.audio = ma;
ma_frame = mirframe(ma,'Length',0.2,'s','Hop',.5);
ma_mel = mirspectrum(ma_frame,'dB','Mel','Length',1024);
ma_env = mirenvelope(ma,'Tau',0.2);
ma_peaks = mirpeaks(ma_env,'Threshold',0.5,'Contrast',0.5);

deltaT = 1.0;   % length of the signal in sec
shiftT = 0.5;   % shift length in sec
P0 = 2e-5;      % sound pressure level reference in Pa
N_tot = []; N_specif = []; LN = []; 
% N_tot     : total loudness, in sone
% N_specif  : specific loudness, in sone/bark
% BarkAxis  : vector of Bark band numbers used for N_specif computation
% LN        : loudness level,in phon
N_time = [];
j = 1;
deltaS = fs * deltaT;
shiftS = fs * shiftT;
endS = length(audio)-deltaS;
for i=0:shiftS:endS
%     display(['calculating ', int2str(j)]);
    VectNiv30ct = gene_ThirdOctave_levels(audio(i+1:i+deltaS),fs,deltaT,P0);
    VectNiv30ct = VectNiv30ct(1:28,:);
    VectNiv30ct = VectNiv30ct(:);
    VectNiv30ct(VectNiv30ct < -60) = -60;
    [N_tot(j),N_specif(j,:),BarkAxis,LN(j)] = Loudness_ISO532B(VectNiv30ct);
    N_time(j,1) = s_start + (j-1)*shiftT;
    N_time(j,2) = N_time(j,1) + deltaT;
    j = j + 1;
end

nelem = numel(N_specif(:,1));
for i=1:nelem
    for j=1:24
        display([int2str(i),' ',int2str(j)]);
        N_specif_tmp(j,:) = N_specif(i,(j-1)*10+1:(j-1)*10+10);
    end
    wstruct.N_specif(i).ary = N_specif_tmp;
end

for i=1:nelem
    wstruct.means(i,:) = mean(wstruct.N_specif(i).ary');
end

wstruct.mean = mean(N_specif_Bark');
wfilename = ['C:\Users\Shunji\Documents\','Table_Loudness_mean.csv'];
csvwrite(wfilename,wstruct.mean);
% end