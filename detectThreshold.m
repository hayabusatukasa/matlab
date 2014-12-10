function [thsld_hi,thsld_low] = ...
    detectThreshold(sig,is_removeTrend,is_plot)

switch nargin
    case 1
        is_removeTrend = 0;
        is_plot = 0;
    case 2
        is_plot = 0;
    otherwise
        
end

sig_orig = sig;
% 信号のトレンド除去
if is_removeTrend == 1
    [p,s,mu] = polyfit((1:numel(sig))',sig,10);
    f_y = polyval(p,(1:numel(sig))',[],mu);
    sig = sig - f_y;
end

% 入力信号の分位数をとってピークの下限とする
[~,q1,q2,q3,~] = quantile(sig);

% ピークの検出
[~,locs_peak] = findpeaks(sig,...
    'MinPeakDistance',200,'MinPeakHeight',q3);

% 信号の極小値の検出
sig_inverted = -sig;
[~,locs_valley] = findpeaks(sig_inverted,...
    'MinPeakDistance',200,'MinPeakHeight',-q1);

% thsld_hi = mean(peak);
% [~,thsld_low,~,~,~] = quantile(sig_orig(locs_valley));
thsld_low = mean(sig_orig(locs_valley));
% thsld_hi = mean(sig_orig(locs_peak));
% thsld_hi = min(sig_orig(locs_peak));
thsld_hi = q1;

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
        xlim([0,length(t)]);
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
        xlim([0,length(t)]);
    end
end
end

