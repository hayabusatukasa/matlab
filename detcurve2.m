function result = detcurve2(x,q1,q2,q3)
% �V�O���C�h�֐���p�����]���֐�
% ����
% x : �ϐ�

% 1/(1+exp(-a*sd))->1���exp(-a*sd)=0.001�ƂȂ�a�����߂�
% -a*sd = log(0.001) = -6.9078
sd1 = q2-q1;
sd2 = q3-q2;
a1 = -log(0.001)/sd1;
a2 = -log(0.001)/sd2;

if x<=q2
    result = 1/(1+exp(-a1*(x-q2+sd1)));
else
    result = 1/(1+exp(a2*(x-q2-sd2)));
end
end