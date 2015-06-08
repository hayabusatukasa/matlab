function [locs_peak,locs_valley] = ...
    getAttackParts(sig,mpd,mph_peak,mph_valley,thr,is_removeTrend,is_plot)
% function [locs_peak,locs_valley] = ...
%   getPeakValley(sig,mpd,mph_peak,mph_valley,thr,is_removeTrend,is_plot)
%
% 与えられた信号からピークと極小値を取得する関数
% 
% Input:
%	sig			: 入力信号
% 	mpd			: MinPeakDistance(default=1)
% 	mph_peak	: MinPeakHeight(for peak, default=-Inf)
% 	mph_valley	: MinPeakHeight(for valley, default=-Inf)
% 	thr			: Threshold(default=0)
% 	is_removeTrend: トレンド除去するかどうか(0 or 1, default=0)
% 	is_plot		: プロットするかどうか(0 or 1, default=1)
% 
% Output:
%	locs_peak	: ピーク位置
%	locs_valley : 極小点位置

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

% ピーク部分の取得
thr = mean(env);
%[~,~,~,thr,~] =  quantile(env);
[~,locs_peak] = findpeaks...
    (env,'MinPeakDistance',mpd,'MinPeakHeight',mph,'Npeaks',aoBeats);

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

