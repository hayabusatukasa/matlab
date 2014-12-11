function audio_output = conbineSampleWithMusic...
    (audio_sample,audio_music,fs,startloop,endloop)

startloop_insample = round(startloop * fs);
endloop_insample = round(endloop * fs);

s = size(audio_sample);
n = 1;
for i=1:s(1)
    if isequal(audio_sample(i,:),zeros(1,length(audio_sample(i,:))))==0
        
    end
    n = n + 1;
end

end

