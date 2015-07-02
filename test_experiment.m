%%
clear all;
[voice1,fs_vo] = audioread('FujitaVoice.wav');
voice2 = audioread('IchiVoice.wav');
voice3 = audioread('IkedaVoice.wav');
voice4 = audioread('KamoVoice.wav');
voice5 = audioread('KobayashiVoice.wav');

[music1,fs_mu1] = audioread('カフェ・タンバリン.m4a');
[music2,fs_mu2] = audioread('クロスロード.m4a');
[music3,fs_mu3] = audioread('スイート・ドリーム・ハニー.m4a');
[music4,fs_mu4] = audioread('ビートスター.m4a');
[music5,fs_mu5] = audioread('レッツ・マーチ.m4a');

time = 60;
voice1 = (voice1(:,1)+voice1(:,2))/2; voice1 = voice1(1:(fs_vo*time));
voice2 = (voice2(:,1)+voice2(:,2))/2; voice2 = voice2(1:(fs_vo*time));
voice3 = (voice3(:,1)+voice3(:,2))/2; voice3 = voice3(1:(fs_vo*time));
voice4 = (voice4(:,1)+voice4(:,2))/2; voice4 = voice4(1:(fs_vo*time));
voice5 = (voice5(:,1)+voice5(:,2))/2; voice5 = voice5(1:(fs_vo*time));
music1 = (music1(:,1)+music1(:,2))/2; music1 = music1(1:(fs_mu1*time));
music2 = (music2(:,1)+music2(:,2))/2; music2 = music2(1:(fs_mu2*time));
music3 = (music3(:,1)+music3(:,2))/2; music3 = music3(1:(fs_mu3*time));
music4 = (music4(:,1)+music4(:,2))/2; music4 = music4(1:(fs_mu4*time));
music5 = (music5(:,1)+music5(:,2))/2; music5 = music5(1:(fs_mu5*time));

%%
ao_sec = 30;
tau = 0.2;
contrast = 0.05;
min_speed = 1.0;
max_speed = 1.25;

%% music1
a_mu1vo1sp = audioSampleGenerator5...
    (music1,fs_mu1,voice1,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);
a_mu1vo2sp = audioSampleGenerator5...
    (music1,fs_mu1,voice2,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);
a_mu1vo3sp = audioSampleGenerator5...
    (music1,fs_mu1,voice3,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);
a_mu1vo4sp = audioSampleGenerator5...
    (music1,fs_mu1,voice4,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);
a_mu1vo5sp = audioSampleGenerator5...
    (music1,fs_mu1,voice5,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);

audiowrite('a_mu1vo1.wav',a_mu1vo1sp,fs_vo);
audiowrite('a_mu1vo2.wav',a_mu1vo2sp,fs_vo);
audiowrite('a_mu1vo3.wav',a_mu1vo3sp,fs_vo);
audiowrite('a_mu1vo4.wav',a_mu1vo4sp,fs_vo);
audiowrite('a_mu1vo5.wav',a_mu1vo5sp,fs_vo);

%% music2
a_mu2vo1sp = audioSampleGenerator5...
    (music2,fs_mu2,voice1,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);
a_mu2vo2sp = audioSampleGenerator5...
    (music2,fs_mu2,voice2,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);
a_mu2vo3sp = audioSampleGenerator5...
    (music2,fs_mu2,voice3,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);
a_mu2vo4sp = audioSampleGenerator5...
    (music2,fs_mu2,voice4,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);
a_mu2vo5sp = audioSampleGenerator5...
    (music2,fs_mu2,voice5,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);

audiowrite('a_mu2vo1.wav',a_mu2vo1sp,fs_vo);
audiowrite('a_mu2vo2.wav',a_mu2vo2sp,fs_vo);
audiowrite('a_mu2vo3.wav',a_mu2vo3sp,fs_vo);
audiowrite('a_mu2vo4.wav',a_mu2vo4sp,fs_vo);
audiowrite('a_mu2vo5.wav',a_mu2vo5sp,fs_vo);

%% music3
a_mu3vo1sp = audioSampleGenerator5...
    (music3,fs_mu3,voice1,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);
a_mu3vo2sp = audioSampleGenerator5...
    (music3,fs_mu3,voice2,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);
a_mu3vo3sp = audioSampleGenerator5...
    (music3,fs_mu3,voice3,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);
a_mu3vo4sp = audioSampleGenerator5...
    (music3,fs_mu3,voice4,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);
a_mu3vo5sp = audioSampleGenerator5...
    (music3,fs_mu3,voice5,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);

audiowrite('a_mu3vo1.wav',a_mu3vo1sp,fs_vo);
audiowrite('a_mu3vo2.wav',a_mu3vo2sp,fs_vo);
audiowrite('a_mu3vo3.wav',a_mu3vo3sp,fs_vo);
audiowrite('a_mu3vo4.wav',a_mu3vo4sp,fs_vo);
audiowrite('a_mu3vo5.wav',a_mu3vo5sp,fs_vo);

%% music4
a_mu4vo1sp = audioSampleGenerator5...
    (music4,fs_mu4,voice1,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);
a_mu4vo2sp = audioSampleGenerator5...
    (music4,fs_mu4,voice2,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);
a_mu4vo3sp = audioSampleGenerator5...
    (music4,fs_mu4,voice3,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);
a_mu4vo4sp = audioSampleGenerator5...
    (music4,fs_mu4,voice4,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);
a_mu4vo5sp = audioSampleGenerator5...
    (music4,fs_mu4,voice5,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);

audiowrite('a_mu4vo1.wav',a_mu4vo1sp,fs_vo);
audiowrite('a_mu4vo2.wav',a_mu4vo2sp,fs_vo);
audiowrite('a_mu4vo3.wav',a_mu4vo3sp,fs_vo);
audiowrite('a_mu4vo4.wav',a_mu4vo4sp,fs_vo);
audiowrite('a_mu4vo5.wav',a_mu4vo5sp,fs_vo);

%% music5
a_mu5vo1sp = audioSampleGenerator5...
    (music5,fs_mu5,voice1,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);
a_mu5vo2sp = audioSampleGenerator5...
    (music5,fs_mu5,voice2,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);
a_mu5vo3sp = audioSampleGenerator5...
    (music5,fs_mu5,voice3,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);
a_mu5vo4sp = audioSampleGenerator5...
    (music5,fs_mu5,voice4,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);
a_mu5vo5sp = audioSampleGenerator5...
    (music5,fs_mu5,voice5,fs_vo,ao_sec,tau,contrast,min_speed,max_speed);

audiowrite('a_mu5vo1.wav',a_mu5vo1sp,fs_vo);
audiowrite('a_mu5vo2.wav',a_mu5vo2sp,fs_vo);
audiowrite('a_mu5vo3.wav',a_mu5vo3sp,fs_vo);
audiowrite('a_mu5vo4.wav',a_mu5vo4sp,fs_vo);
audiowrite('a_mu5vo5.wav',a_mu5vo5sp,fs_vo);