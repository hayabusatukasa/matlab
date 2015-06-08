function p=CrossCorrelation_(x,window_size)
p=zeros(1,window_size);
den1=0;
for n=1:window_size,
   den1=den1+x(n)*x(n);
end
den1=sqrt(den1);
for m=1:window_size,
   den2=0;
   for n=1:window_size,
      den2=den2+x(n+m-1)*x(n+m-1);
   end
   den2=sqrt(den2);
   for n=1:window_size,
      p(m)=p(m)+x(n)*x(n+m-1);
   end
   p(m)=p(m)/(den1*den2);
end
