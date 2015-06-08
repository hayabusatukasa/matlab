function audio_output = ConvertAudioSpeed(audio_input, fs, convert_length)

fmin = 80; % Hz

R = convert_length/length(audio_input);
if R < 1.0
    audio_output = CompressAudio(audio_input, fs, convert_length, fmin);
elseif R > 1.0
    audio_output = StretchAudio(audio_input, fs, convert_length, fmin);
else
    audio_output = audio_input;
    return;
end

audio_output = resample(audio_output,convert_length,length(audio_output));
%audio_output = audio_output(1:convert_length);

end

function x = CompressAudio(audio_input, fs, convert_length, fmin)

L = 0;
R = convert_length/length(audio_input);
framelen = 2*round(fs/fmin);
x = audio_input;
xlen = length(x);
while L < xlen-framelen
    fr = x((L+1):(L+framelen));
    p = PitchExtraction_(fr,fs);
    if p~=0
        origA_L = x((L+1):(L+p));
        origB_L = x((L+p+1):(L+p+p));
        env1to0 = linspace(1,0,p);
        env0to1 = linspace(0,1,p);
        waveA_L = origA_L.*env1to0';
        waveB_L = origB_L.*env0to1';
        waveC_L = waveA_L+waveB_L;
        x = vertcat(x(1:L),waveC_L,x((L+p*2+1):end));
        L = L + round(R*p/(1-R));
    else
        Rlen = round(length(fr)*R);
        wave = resample(fr, Rlen, length(fr));
        x = vertcat(x(1:L), wave, x((L+framelen+1):end));
        L = L + Rlen;
    end
    xlen = length(x);
end

end

function x = StretchAudio(audio_input, fs, convert_length, fmin)
L = 0;
R = convert_length/length(audio_input);
framelen = 2*round(fs/fmin);
x = audio_input;
xlen = length(x);
while L < xlen-framelen
    fr = x((L+1):(L+framelen));
    p = PitchExtraction_(fr,fs);
    if p~=0
        origA_L = x((L+1):(L+p));
        origB_L = x((L+p+1):(L+p+p));
        env1to0 = linspace(1,0,p);
        env0to1 = linspace(0,1,p);
        waveA_L = origA_L.*env0to1';
        waveB_L = origB_L.*env1to0';
        waveC_L = waveA_L+waveB_L;
        x = vertcat(x(1:L),origA_L,waveC_L,origB_L,x((L+p*2+1):end));
        L = L + p + round(p / (R-1));
    else
        Rlen = round(length(fr)*R);
        wave = resample(fr, Rlen, length(fr));
        x = vertcat(x(1:L), wave, x((L+framelen+1):end));
        L = L + Rlen;
    end
    xlen = length(x);
end


end