function res = dist(x1,x2)

if length(x1)~=length(x2)
    error('ƒxƒNƒgƒ‹‚ª“¯‚¶’·‚³‚Å‚Í‚ ‚è‚Ü‚¹‚ñ');
end

res = sqrt(sum((x1-x2).^2));
end