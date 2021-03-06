function audio_output = audioSampleGenerator2...
    (audio_input,fs,tau,bpm,bars,beatperbar,noteunit,is_plot)
% オーディオ素材を音楽用のサンプルに仕上げる関数
% 14/12/10
%   audio_outputの長さが正確ではない不具合有．
%   ピークが正しくとれていないときにエラーメッセージのみ表示して出力は
%   どうにもしていない．
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

% audio_outputの秒数を取得
beat_interval = 60/bpm*(4/noteunit); % [sec]
aoBeats = bars*beatperbar;
aoSecLength = beat_interval*aoBeats; % [sec]
aoSampleLength = aoSecLength * fs; % [sample]
bisample = round(beat_interval*fs); % [sample]

% audio_outputの秒数 > audio_inputの秒数のとき，エラーを返す
aiSampleLength = length(audio_input);
if aoSampleLength > aiSampleLength
    warning('too short audio input');
    audio_output = [];
    return
end

% audio_inputから局所的エンベロープを取得
ws_mic = round(fs*tau);
env_mic = movingAverage(abs(audio_input),ws_mic);

% 局所的エンベロープからピークを取得
thr = mean(env_mic);
[~,locs_peak_mic] = findpeaks(env_mic,'MinPeakDistance',bisample,'MinPeakHeight',thr);

% audio_inputから大局的にエンベロープを取得
ws_mac = bisample;
env_mac = movingAverage(abs(audio_input),ws_mac);
N_downsample = fs/10;
env_mac_ds = downsample(env_mac,N_downsample);

% 大局的エンベロープからピークを取得
thr = mean(env_mac_ds);
[~,locs_peak_mac] = findpeaks(env_mac_ds,'MinPeakHeight',thr,...
    'MinPeakDistance',round(fs/N_downsample));

env_mac_us = resample(env_mac_ds,N_downsample,1);

figure;
t = linspace(0,length(env_mic)/fs,length(env_mic));
subplot(2,1,1);
plot(t,audio_input);
subplot(2,1,2);
plot(t(1:(end-ws_mic)),env_mic((ws_mic+1):end));hold all;
plot((locs_peak_mic-ws_mic)/fs,env_mic((locs_peak_mic)),...
    'rv','MarkerFaceColor','r');
plot(t(1:(end-ws_mac)),env_mac((ws_mac+1):end));
plot((locs_peak_mac*N_downsample-ws_mac)/fs,env_mac((locs_peak_mac*N_downsample)),...
    'rv','MarkerFaceColor','b');
% stem(locs_peak,env_rs(locs_peak));
hold off;

% ピークごとに直前の極小点を取得
for i=1:length(locs_peak)      
    % 今見ているピークから1つ前のピークまでの区間のエンベロープを取得し，
    % それを反転させる
    if i>1
        locs = (locs_peak(i-1)+1):locs_peak(i);
    else
        locs = 1:locs_peak(i);
    end
    env_rev = flipud(env_rs(locs));
    
    % 反転させたエンベロープから，ピークの直前で1つだけ極小点を取得
    env_rev_inverted = (-env_rev);
    thr = mean(env_rev_inverted);
    [~,locs_rev] = findpeaks(env_rev_inverted,'NPeaks',1);
    
    if isempty(locs_rev) == 0
        locs_valley(i) = locs_peak(i) - locs_rev;
    else % 極小点が取れなかったとき，ピークの0.01秒前を極小点とする
        display(['index ',num2str(i),' valley not found']);
        if locs_peak(i) > floor(fs/100)
            locs_valley(i) = locs_peak(i) - floor(fs/100);
        else 
            locs_valley(i) = 1;
        end
    end
end

i_start = 1;
j = 1;
while (locs_valley(j)-windowSize) < 1
    i_start = i_start + 1;
    aoBeats = aoBeats + 1;
    j = j + 1;
end

audio_output = [];
if length(locs_peak)<aoBeats
    warning('too short peaks');
    return;
end

if (locs_valley(aoBeats)-windowSize+bisample)>length(audio_input)
    warning('false to make audio sample');
    return;
end

% 検出したピークを起点にして，ビートごとに音をつなぎ合わせる
for i=i_start:aoBeats
    s_start = locs_valley(i)-windowSize;
    s_end = s_start + bisample;
    a_tmp = audio_input(s_start:s_end);
    audio_output = cat(1,audio_output,a_tmp);
end

% 検出したピークのプロット
if is_plot ~= 0
    t = linspace(0,length(env)/fs,length(env_rs));
    figure;
    hold on;
    plot(t,env);
    plot(locs_peak/fs,env_rs(locs_peak),'rv','MarkerFaceColor','r');
    plot(locs_valley/fs,env_rs(locs_valley),'rs','MarkerFaceColor','b');
    hold off;
    xlim([0 length(env)/fs]);
    title(['Audio Peak Picking tau=',num2str(windowSize/fs)]);
end

end

