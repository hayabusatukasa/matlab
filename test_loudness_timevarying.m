fname_withoutWAV = '141105_001';
filename = [fname_withoutWAV,'.WAV'];
a_info = audioinfo(filename);
fs = a_info.SampleRate;
s_start = 0;
s_end = 60;
a = audioread(filename,[fs*s_start+1,fs*s_end]);
a = (a(:,1)+a(:,2))/2;

t = cputime;
result = Loudness_TimeVaryingSound_Zwicker(a,fs,'mic','free',5,0.1,true);
display(cputime-t);

t= cputime;
clear S;
S = zeros(1,length(result.InstantaneousLoudness));
for i=1:length(result.InstantaneousLoudness)
    S(i) = sharpness(result.barkAxis,...
        result1.InstantaneousSpecificLoudness(i,:),...
        result1.InstantaneousLoudness(i));
end
display(cputime-t);
