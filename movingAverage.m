function env = movingAverage(sig,windowSize)
% env = movingAverage(sig,windowSize)
% 基本的な移動平均フィルタ
%
% Input:
%	sig			: 信号
%	windowSize	: タップ数(sample)
%
% Output:
%	env			: 移動平均フィルタを適用した信号

coeff = ones(1,windowSize)/windowSize;
env = filter(coeff,1,sig);

halfws = floor(windowSize/2);
env = [env((halfws+1):end);zeros(halfws,1)];
for i=1:windowSize
    t_sig = sig((length(sig)-windowSize+i):end);
    ws = length(t_sig);
    env((length(env)-windowSize+i):end) = sum(t_sig)/ws;
end

end
