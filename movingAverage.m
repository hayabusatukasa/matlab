function env = movingAverage(sig,windowSize)

coeff = ones(1,windowSize)/windowSize;
env = filter(coeff,1,sig);

end