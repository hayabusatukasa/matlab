a = [0 1 3 5 5 6 7 10 10 10 20 20 20 25 30];
[min,q1,q2,q3,max] = quantile(a);
t = linspace(min,max,1000);

for i=1:length(t)
    result(i) = detcurve2(t(i),q1,q2,q3);
end

figure; plot(t,result);
xlabel('Input Value');
ylabel('Output Value');
grid on;
set(gca,'YTick',0:0.25:1.0);