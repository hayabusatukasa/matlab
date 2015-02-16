function env = movingAverage(sig,windowSize)
% env = movingAverage(sig,windowSize)
% ��{�I�Ȉړ����σt�B���^
%
% Input:
%	sig			: �M��
%	windowSize	: �^�b�v��(sample)
%
% Output:
%	env			: �ړ����σt�B���^��K�p�����M��

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
