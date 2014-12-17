function audio_output = audioSampleGenerator...
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
beat_interval = 60/bpm*(noteunit/beatperbar); % [sec]
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

% audio_inputからエンベロープを取得
windowSize = round(fs*tau);
env = movingAverage(abs(audio_input),windowSize);

% エンベロープからピークを取得
thr = mean(env);
[~,locs_peak] = findpeaks(env,'MinPeakDistance',bisample,'MinPeakHeight',thr);

% ピークごとに直前の極小点を取得
for i=1:length(locs_peak)      
    % 今見ているピークから1つ前のピークまでの区間のエンベロープを取得し，
    % それを反転させる
    if i>1
        locs = (locs_peak(i-1)+1):locs_peak(i);
    else
        locs = 1:locs_peak(i);
    end
    env_rev = flipud(env(locs));
    
    % 反転させたエンベロープから，ピークの直前で1つだけ極小点を取得
    env_rev_inverted = (-env_rev);
    thr = mean(env_rev_inverted);
    [~,locs_rev] = findpeaks(env_rev_inverted,...
        'NPeaks',1,'MinPeakHeight',thr,'Threshold',0);
    
    if isempty(locs_rev) == 0
        locs_valley(i) = locs_peak(i) - locs_rev;
    else % 極小点が取れなかったとき，ピークの0.01秒前を極小点とする
        warning(['in ',num2str(i),'th peak: not found valley']);
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
    t = linspace(0,length(env)/fs,length(env));
    figure;
    hold on;
    plot(t,env);
    plot(locs_peak/fs,env(locs_peak),'rv','MarkerFaceColor','r');
    plot(locs_valley/fs,env(locs_valley),'rs','MarkerFaceColor','b');
    hold off;
    xlim([0 length(env)/fs]);
    title(['Audio Peak Picking tau=',num2str(tau)]);
end

end

