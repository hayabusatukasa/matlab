[~,q1,q2,q3,~] = quantile(sf);

[p,s,mu] = polyfit((1:numel(sf))',sf,6);
f_y = polyval(p,(1:numel(sf))',[],mu);
sf_RemevedTrend = sf - f_y;

[peak,locs_peak] = findpeaks(sf,...
    'MinPeakDistance',100,'MinPeakHeight',q3);
sf_inverted = -sf;
[valley,locs_valley] = findpeaks(sf_inverted,...
    'MinPeakDistance',100,'MinPeakHeight',-q1);

peak_mean = mean(peak);
valley_mean = mean(valley);

t = linspace(0,length(sf),length(sf));
figure; 
hold on;
plot(t,sf);
plot(locs_peak,sf(locs_peak),'rv','MarkerFaceColor','r');
plot(locs_valley,sf(locs_valley),'rs','MarkerFaceColor','b');
plot(t,linspace(peak_mean,peak_mean,length(t)),'LineStyle',':','Color','r');
plot(t,-linspace(valley_mean,valley_mean,length(t)),'LineStyle',':','Color','b');
hold off;
