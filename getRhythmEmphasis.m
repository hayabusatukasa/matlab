function [a_reno,a_rehi,a_relow] = ...
    getRhythmEmphasis(audio_input,fs,bpm,bars,beatperbar,noteunit)

beat_interval = 60/bpm*(noteunit/beatperbar); % [sec]
aoBeats = bars*beatperbar;
bisample = round(beat_interval*fs); % [sample]
aoSampleLength = bisample*aoBeats; % [sample]

attack  = round(0.001*fs);
release = round(0.001*fs);
decay   = floor(bisample/2)-attack;
sustain = ceil(bisample/2)-release;

% ビート強調なし
avalue  = 0.0;
dvalue  = 1.0;
svalue  = 1.0;
rvalue  = 0.0;
adsr = getADSR(attack,decay,sustain,release,avalue,dvalue,svalue,rvalue);
fade10 = [];
for i=1:aoBeats
    fade10 = [fade10,adsr];
end

% ビート強調（強）
avalue  = 0.0;
dvalue  = 1.0;
svalue  = 0.5;
rvalue  = 0.0;
adsr = getADSR(attack,decay,sustain,release,avalue,dvalue,svalue,rvalue);
fade05 = [];
for i=1:aoBeats
    fade05 = [fade05,adsr];
end

% ビート強調（弱）
avalue  = 0.0;
dvalue  = 1.0;
svalue  = 0.8;
rvalue  = 0.0;
adsr = getADSR(attack,decay,sustain,release,avalue,dvalue,svalue,rvalue);
fade08 = [];
for i=1:aoBeats
    fade08 = [fade08,adsr];
end

a_reno = audio_input.*fade10';
a_rehi = audio_input.*fade05';
a_relow = audio_input.*fade08';

end