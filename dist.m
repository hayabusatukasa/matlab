function res = dist(x1,x2)

if length(x1)~=length(x2)
    error('�x�N�g�������������ł͂���܂���');
end

res = sqrt(sum((x1-x2).^2));
end