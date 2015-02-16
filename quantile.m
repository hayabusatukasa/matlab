function [min,q1,q2,q3,max] = quantile(x)
% [min,q1,q2,q3,max] = quantile(x)
% 1�����̃x�N�g������l���ʓ_���擾����֐�
% Input:
% 	x	: 1�����̃x�N�g��
% 
% Output:
%	min	: �ŏ��l
% 	q1	: ��1�l���ʓ_
% 	q2	: ��2�l���ʓ_
% 	q3	: ��3�l���ʓ_
% 	max	: �ő�l

len = length(x);
x_sort = sort(x);
min = x_sort(1);
max = x_sort(end);
if mod(len,2)==1
    mi = (len+1)/2;
    q2 = x_sort(mi);
    q1 = median(x_sort(1:mi));
    q3 = median(x_sort(mi:end));
else
    mi = len/2;
    q2 = (x_sort(mi)+x_sort(mi+1))/2;
    q1 = median(x_sort(1:mi));
    q3 = median(x_sort((mi+1):end));
end
end
