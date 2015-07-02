[yu,fs] = audioread('IchiVoice.wav');
[le,fs] = audioread('lead.wav');

ao_sec = 30;
tau = 0.2;
contrast = 0.05;
min_speed = 1.0;
max_speed = 1.5;

bpm = 88;
beatperbar = 4;
noteunit = 4;

a_out1 = audioSampleGenerator6(bpm,beatperbar,noteunit,yu(1:(60*fs),1),fs,...
    ao_sec+10,tau,contrast,min_speed,max_speed);

a_out2 = Vocoder(a_out1',le,fs,ao_sec);

len = length(a_out2);
mix = 0.2*a_out1(1:len)+0.8*a_out2;
audiowrite('vocoder_out.wav',mix,fs);
