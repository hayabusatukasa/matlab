function pitch=PitchExtraction_(e,fs)
length_of_e=length(e);
p=CrossCorrelation_(e,length_of_e/2);
highest_pitch=round(fs/400);
lowest_pitch=round(fs/80);
peak=0;
for m=highest_pitch:lowest_pitch,
   if peak<p(m)
      peak=p(m);
      pitch=m-1;
   end
end
if peak<0.1
   pitch=0;
end
