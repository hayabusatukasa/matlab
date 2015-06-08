function audio_output = audioSampleGenerator_refactored2...
    (audio_input,fs,tau,bpm,bars,beatperbar,noteunit,is_plot)
% オーディオ素材を音楽用のサンプルに仕上げる関数
% 14/12/10
%   audio_outputの長さが正確ではない不具合有．
%   ピークが正しくとれていないときにエラーメッセージのみ表示して出力は
%   どうにもしていない．
% 15/01/09
%   どうにかした．
%   ピークが十分に取れていないときはaudio_inputの冒頭audio_output
%   の長さの分をaudio_outputとして返す．
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
bisample = round(beat_interval*fs); % [sample]
aoSampleLength = bisample*aoBeats; % [sample]

% audio_outputの秒数 > audio_inputの秒数のとき，エラーを返す
aiSampleLength = length(audio_input);
if aoSampleLength > aiSampleLength
    error('too short audio input');
end

% audio_inputからエンベロープを取得
windowSize = round(fs*tau);
env = movingAverage(abs(audio_input),windowSize);
dsrate = 100;
envds = resample(env,1,dsrate);
envrs = interp(envds,dsrate);
env = envrs(1:length(env));

% エンベロープからピークを取得
%thr = mean(env);
[~,q1_env,q2_env,q3_env,~] =  quantile(env);
[locs_peak,locs_valley] = getPeakValley...
    (env,round(length(env)/(aoBeats)),q3_env,-q1_env,0,0,1);

num_valley = length(locs_valley);
num_peak = length(locs_peak);
for i=1:(num_valley-1)
    % 極小点間のサンプル長を取得
    len_valleyDistance(i) = locs_valley(i+1) - locs_valley(i);

    % 極小点間のピーク数を取得
    num_peaks_valleyDistance(i) = 0;
    for j=1:num_peak
        if locs_peak(j)>locs_valley(i) && locs_peak(j)<locs_valley(i+1)
            num_peaks_valleyDistance(i) = num_peaks_valleyDistance(i) + 1;
        end
    end
end

% 極小点間の長さを拍単位で取得
len_valleyDistance_inBeat = len_valleyDistance / bisample;
lvDiB_floor = floor(len_valleyDistance_inBeat);

i_start = 1;
% j = 1;
% while (locs_valley(j)-windowSize) < 1
%     i_start = i_start + 1;
%     aoBeats = aoBeats + 1;
%     j = j + 1;
% end

audio_output = [];
if length(locs_peak)<aoBeats
    display('Too short peaks.');
    if beatperbar>1
        display('Restart sample generate in beatperbar/2.');
        audio_output = audioSampleGenerator_refactored2...
            (audio_input,fs,tau,bpm,bars,beatperbar/2,noteunit,0);
        if length(audio_output) > aoSampleLength
            audio_output = audio_output(1:aoSampleLength);
        elseif length(audio_output) < aoSampleLength
            audio_output = [audio_output; ...
                zeros(aoSampleLength-length(audio_output),1)];
        end
    else
        display('Return input audio.');
        audio_output = audio_input(1:aoSampleLength);
    end
    audio_plot = audio_output;
    s_start_plot = 1;
    s_end_plot = aoSampleLength;
    aoBeats = 1;

elseif (locs_valley(aoBeats)+bisample-1)>length(audio_input)
    warning('False to make audio sample. Return input audio.');
    audio_output = audio_input(1:aoSampleLength);
    audio_plot = audio_output;
    s_start_plot = 1;
    s_end_plot = aoSampleLength;
    aoBeats = 1;
    
else
    % 検出したピークを起点にして，ビートごとに音をつなぎ合わせる
    for i=i_start:aoBeats
        s_start = locs_valley(i)+round(windowSize/2);
        s_end = s_start + bisample - 1;
        a_tmp = audio_input(s_start:s_end);
        audio_output = cat(1,audio_output,a_tmp);
        audio_plot(i,:) = a_tmp;
        s_start_plot(i) = s_start;
        s_end_plot(i) = s_end;
    end
end

if is_plot ~= 0
    figure;
    subplot(3,1,1);
    t = linspace(0,length(audio_input)/fs,length(audio_input));
    hold on;
    plot(t,audio_input,'Color','b');
    if aoBeats==1
        plot(t(s_start_plot:s_end_plot),audio_plot,'Color','r');
    else
        for i=1:aoBeats
            plot(t(s_start_plot(i):s_end_plot(i)),audio_plot(i,:),'Color','r');
        end
    end
    hold off;
    %title('Audio used for generating');
    xlim([0 length(audio_input)/fs]);
    xlabel('Time [s]');
    ylabel('Amplitude');
    %legend('audio unused for sample','audio used for sample');
    
    %figure;
    subplot(3,1,2);
    t = linspace(0,length(env)/fs,length(env));
    plot(t,abs(audio_input)*max(env),'Color','b');
    hold on;
    plot(t,env,'Color','g');
    plot(locs_peak/fs,env(locs_peak),'rv','MarkerFaceColor','r');
    plot(locs_valley/fs,env(locs_valley),'rs','MarkerFaceColor','b');
    hold off;
    xlim([0 length(audio_input)/fs]);
    %title(['Audio Peak Picking tau=',num2str(tau)]);
    xlabel('Time [s]');

    %figure;
    subplot(3,1,3);
    t = linspace(0,aoBeats,length(audio_output));
    plot(t,audio_output,'Color','r');
    grid on;
    set(gca,'XTick',[0:1:aoBeats]);
    %set(gca,'YTick',[-1.0:0.5:1.0]);
    %title('Generated Audio Sample');
    xlabel('Beat');
    ylabel('Amplitude');
    xlim([0,aoBeats]);
    %ylim([-1.0,1.0]);
    
%     figure;
%     % subplot(3,1,1);
%     t = linspace(0,length(audio_input)/fs,length(audio_input));
%     hold on;
%     plot(t,audio_input,'Color','b');
%     %title('Audio used for generating');
%     xlim([0 20]);
%     xlabel('Time [s]');
%     ylabel('Amplitude');
end

end

