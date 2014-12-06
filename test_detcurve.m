fs = 44100;
t = linspace(-5,20,fs);
a = [1 1 1 1 2 3 4 10 16 20];
m = mean(a);
sd = std(a);
% q1 = 1;
% q2 = 2.5;
% q3 = 4.75;
[~,q1,q2,q3,~] = quantile(a);
for i=1:length(a)
    dc1(i) = detcurve(a(i),m,sd);
    dc2(i) = detcurve2(a(i),q1,q2,q3);
end
for i=1:fs
    dc1_t(i) = detcurve(t(i),m,sd);
    dc2_t(i) = detcurve2(t(i),q1,q2,q3);
end
figure; 
subplot(2,1,1); plot(t,dc1_t);
subplot(2,1,2); plot(t,dc2_t);

