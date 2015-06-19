function audio_output = Compressor(audio_input, gain, thr1, thr2)

chan = length(audio_input(:,1));
audio_output = zeros(chan, length(audio_input(1,:)));

for c=1:chan
    in = gain*audio_input(c,:);
    low = abs(in) < thr1;
    hi  = abs(in) >= thr1;
    audio_output(c, low) = in(low);
    audio_output(c, hi)  = in(hi)*thr2;
    
    is_up1 = audio_output(c,:)>1;
    is_lowminus1 = audio_output(c,:)<-1;
    audio_output(c,is_up1) = 1;
    audio_output(c,is_lowminus1) = -1;
end

end
