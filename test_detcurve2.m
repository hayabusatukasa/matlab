a = T_param.cent(1900:2000);
[min,q1,q2,q3,max] = quantile(a);
t = linspace(min,max,1000);

for i=1:length(t)
    result(i) = detcurve2(t(i),q1,q2,q3);
end

figure; plot(t,result);