bpm=100;
bars=4;
noteunit=4;
tau=0.2;

%%
bpb=1;
a_asg = audioSampleGenerator_refactored...
    (data(:,1),fs,tau,bpm,bars,bpb,noteunit,1);
[a_reno,a_rehi,a_relow] = getRhythmEmphasis(a_asg,fs,bpm,bars,bpb,noteunit);

audiowrite('reno_bpm100_bars4_bpb1.wav',a_reno,fs);
audiowrite('relo_bpm100_bars4_bpb1.wav',a_relow,fs);
audiowrite('rehi_bpm100_bars4_bpb1.wav',a_rehi,fs);

%%
bpb=2;
a_asg = audioSampleGenerator_refactored...
    (data(:,1),fs,tau,bpm,bars,bpb,noteunit,1);
[a_reno,a_rehi,a_relow] = getRhythmEmphasis(a_asg,fs,bpm,bars,bpb,noteunit);

audiowrite('reno_bpm100_bars4_bpb2.wav',a_reno,fs);
audiowrite('relo_bpm100_bars4_bpb2.wav',a_relow,fs);
audiowrite('rehi_bpm100_bars4_bpb2.wav',a_rehi,fs);

%%
bpb=4;
a_asg = audioSampleGenerator_refactored...
    (data(:,1),fs,tau,bpm,bars,bpb,noteunit,1);
[a_reno,a_rehi,a_relow] = getRhythmEmphasis(a_asg,fs,bpm,bars,bpb,noteunit);

audiowrite('reno_bpm100_bars4_bpb4.wav',a_reno,fs);
audiowrite('relo_bpm100_bars4_bpb4.wav',a_relow,fs);
audiowrite('rehi_bpm100_bars4_bpb4.wav',a_rehi,fs);

%%
bpb=8;
a_asg = audioSampleGenerator_refactored...
    (data(:,1),fs,tau,bpm,bars,bpb,noteunit,1);
[a_reno,a_rehi,a_relow] = getRhythmEmphasis(a_asg,fs,bpm,bars,bpb,noteunit);

audiowrite('reno_bpm100_bars4_bpb8.wav',a_reno,fs);
audiowrite('relo_bpm100_bars4_bpb8.wav',a_relow,fs);
audiowrite('rehi_bpm100_bars4_bpb8.wav',a_rehi,fs);

%%
audiowrite('original.wav',data(:,1),fs);
