function audio_output = audioSampleGenerator4(music_fname,audio_input,fs,tau)
% audio_output = audioSampleGenerator...
%   (audio_input,fs,tau,bpm,bars,beatperbar,noteunit,is_plot)
% 音楽素材作成関数
%
% Input:
%     audio   : オーディオ素材(モノラルのみ)
%     fs      : サンプリング周波数
%     tau     : 移動平均フィルタのフレーム長(in sec)
%     bpm     : 1分あたりのビート数(Beats per Minute)
%     bars    : 小節数
%     beatperbar : 1小節あたりの拍数
%     noteunit   : 単位音符 (noteunit = 2^n)
%     is_plot : ピーク検出結果をプロットするかどうか (0:off else:on)
%
% Output:
%     audio_output : 音楽素材

% 音楽情報を取得
ma = miraudio(music_fname);
mtempo = mirtempo(ma);
tempo = mirgetdata(mtempo);
beat_interval = 60/tempo;

[mu,fs_music] = audioread(music_fname);

windowSize = round(fs_music*tau);
env = movingAverage(abs(mu),windowSize);
dsrate = 100;
envds = resample(env,1,dsrate);
envrs = interp(envds,dsrate);
env = envrs(1:length(env));

thr = mean(env);
[onset1,~] = getPeakValley(env,floor(beat_interval*fs_music),thr,-thr,0,0,0);
% monset = mironsets(mpeak)
% onset = mirgetdata(monset);

% % 
% ma = miraudio(audio_input,fs);
% monset = mironsets(ma,'Contrast',beat_interval)
% locs_valley = mirgetdata(monset);
% if length(onset) > length(locs_valley)
%     error('Too many onsets');
% end

% audio_inputからエンベロープを取得
windowSize = round(fs*tau);
env = movingAverage(abs(audio_input),windowSize);
dsrate = 100;
envds = resample(env,1,dsrate);
envrs = interp(envds,dsrate);
env = envrs(1:length(env));

% エンベロープからピークを取得
thr = mean(env);
[onset2,~] = getPeakValley(env,floor(beat_interval*fs),thr,-thr,0,0,0);

% 音楽のonsetから
m_info = audioinfo(music_fname);
onset1 = onset1*(fs/fs_music);
%locs_valley = floor(locs_valley*fs);
audio_output = zeros(1,floor(m_info.Duration*fs));
n_ons1 = 1;
n_ons2 = 1;
ons1 = onset1(n_ons1);
ons2 = onset1(n_ons1+1)-1;
ons2ons12 = ons2 - ons1 + 1;
ons3 = onset2(n_ons2);
ons4 = onset2(n_ons2+1)-1;
ons2ons34 = ons4-ons3+1;
ratio = ons2ons34/ons2ons12;
while 1
    disp([num2str(n_ons1),'/',num2str(length(onset1))]);
    if 1.0 < ratio && ratio < 1.8
        a_org = audio_input(ons3:ons4);
        a_conv = ConvertAudioSpeed(a_org,fs,ons2ons12);
        audio_output(ons1:ons2) = a_conv;
        n_ons1 = n_ons1+1;
        n_ons2 = n_ons2+1;
        if n_ons1+1 > length(onset1) || n_ons2+1 > length(onset2)
            break;
        end
        ons1 = onset1(n_ons1);
        ons2 = onset1(n_ons1+1)-1;
        ons2ons12 = ons2 - ons1 + 1;
        ons3 = onset2(n_ons2);
        ons4 = onset2(n_ons2+1)-1;
        ons2ons34 = ons4-ons3+1;
        ratio = ons2ons34/ons2ons12;
    elseif ratio >= 1.8
        n_ons1 = n_ons1+1;
        if n_ons1+1 > length(onset1)
            a_org = audio_input(ons3:ons4);
            a_conv = ConvertAudioSpeed(a_org,fs,ons2ons12);
            audio_output(ons1:ons2) = a_conv;
            break;
        end
        ons2 = onset1(n_ons1+1)-1;
        ons2ons12 = ons2 - ons1 + 1;
        ratio = ons2ons34/ons2ons12;
    elseif 1.0 >= ratio
        n_ons2 = n_ons2 + 1;
        if n_ons2+1 > length(onset2)
            a_org = audio_input(ons3:ons4);
            a_conv = ConvertAudioSpeed(a_org,fs,ons2ons12);
            audio_output(ons1:ons2) = a_conv;
            break;
        end
        ons4 = onset2(n_ons2+1)-1;
        ons2ons34 = ons4-ons3+1;
        ratio = ons2ons34/ons2ons12;
    end
end

end