fname_withoutWAV = '141105_001';
filename = [fname_withoutWAV,'.WAV'];
a_info = audioinfo(filename);
fs = a_info.SampleRate;
i_stop = floor(a_info.Duration/60)-1;
t_total = cputime;
for i=0:i_stop
    s_start = i*60;
    s_end = (i+1)*60;
    audio = audioread(filename, [s_start*fs+1,s_end*fs]);
    if a_info.NumChannels > 1
        audio = (audio(:,1)+audio(:,2))/2;
    end
    display(['calculating ',num2str(i),' to ',num2str(i+1)]);
    t_part = cputime;
    res =Loudness_TimeVaryingSound_Zwicker(audio,fs,'mic','free',5,0.05,false);
    S = zeros(1,length(res.InstantaneousLoudness));
    for j=1:length(res.InstantaneousLoudness)
        S(j) = sharpness(res.barkAxis,...
            res.InstantaneousSpecificLoudness(j,:),...
            res.InstantaneousLoudness(j));
    end
    t_part = cputime - t_part;
    display(['ŒvZŠÔ‚Í ',num2str(t_part),' •b‚Å‚·']);
    time = s_start+res.time;
    T = table(time',res.InstantaneousLoudnessLevel',S',...
        'VariableNames',{'Time','LoudnessLevel','Sharpness'});
    wPass = ['C:\Users\Shunji\Documents\ŠÂ‹«‰¹csv\Loudness_TimeVarying',...
        fname_withoutWAV,'\'];
    wFilename = [wPass,'Table_Loudness_Parameters_',...
            num2str(s_start),'to',num2str(s_end),'.csv'];
    writetable(T,wFilename);
end
t_total = cputime - t_total;
display(['ƒg[ƒ^ƒ‹‚ÌŒvZŠÔ‚Í ',num2str(t_total),' •b‚Å‚·']);
