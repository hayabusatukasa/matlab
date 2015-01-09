function vw = getWeight(v,w)
if w>1
    vw = log(v)./log(w);
elseif w==1
    vw = log(v)./log(1.1);
else
    vw = log(v)./log(w);
end
end