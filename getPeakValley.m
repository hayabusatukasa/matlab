function [locs_peak,locs_valley] = ...
    getPeakValley(sig,mpd,mph_peak,mph_valley,thr,is_removeTrend,is_plot)

if nargin<2; mpd = 1; end;
if nargin<3; mph_peak = -Inf; end;
if nargin<4; mph_valley = -Inf; end;
if nargin<5; thr = 0; end;
if nargin<6; is_removeTrend = 0; end;
if nargin<7; is_plot = 1; end;

sig_orig = sig;
% 信号のトレンド除去
if is_removeTrend == 1
    [p,s,mu] = polyfit((1:numel(sig))',sig,10);
    f_y = polyval(p,(1:numel(sig))',[],mu);
    sig = sig - f_y;
end

% ピークの検出
[~,locs_peak] = findpeaks(sig,'MinPeakDistance',mpd,...
    'MinPeakHeight',mph_peak,'Threshold',thr);

% 信号の極小値の検出
sig_inverted = -sig;
[~,locs_valley] = findpeaks(sig_inverted,'MinPeakDistance',mpd,...
    'MinPeakHeight',mph_valley,'Threshold',thr);

if is_plot == 1
    t = 1:length(sig);
    figure;
    if is_removeTrend == 1
        subplot(3,1,1);
        plot(t,sig_orig); grid on; title('Original Signal'); 
        xlim([0,length(t)]);
        subplot(3,1,2);
        plot(t,sig); grid on; title('Signal Removed Trend');
        xlim([0,length(t)]);
        subplot(3,1,3);
        hold on;
        plot(t,sig);
        plot(locs_peak,sig(locs_peak),'rv','MarkerFaceColor','r');
        plot(locs_valley,sig(locs_valley),'rs','MarkerFaceColor','b');
        hold off;
        grid on; title('Peaks and Valleys');
        xlim([1,length(t)]);
    else
        subplot(2,1,1);
        plot(t,sig); grid on; title('Signal'); xlim([0,length(t)]);
        subplot(2,1,2);
        hold on;
        plot(t,sig);
        plot(locs_peak,sig(locs_peak),'rv','MarkerFaceColor','r');
        plot(locs_valley,sig(locs_valley),'rs','MarkerFaceColor','b');
        hold off;
        grid on; title('Peaks and Valleys');
        xlim([1,length(t)]);
    end
end
end

