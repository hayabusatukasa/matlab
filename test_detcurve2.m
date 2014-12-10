a = [1 3 4 5 6 7 8 9 16 20 25 30];
[min,q1,q2,q3,max] = quantile(a);
t = linspace(min,max,1000);

for i=1:length(t)
    result(i) = detcurve2(t(i),q1,q2,q3);
end

figure; plot(t,result);