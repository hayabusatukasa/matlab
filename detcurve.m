function result = detcurve(x,m,sd)
% �V�O���C�h�֐���p�����]���֐�
% ����
% x : �ϐ�
% m : ���ρC�������͒����l
% sd: �W���΍�

% 1/(1+exp(-a*sd))->1���exp(-a*sd)=0.001�ƂȂ�a�����߂�
% -a*sd = log(0.001) = -6.9078
a = 6.9078/sd;
if x<=m
    result = 1/(1+exp(-a*(x-m+sd)));
else
    result = 1/(1+exp(a*(x-m-sd)));
end
end