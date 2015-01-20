function adsr = getADSR(attack,decay,sustain,release,avalue,dvalue,svalue,rvalue)
% sig = getAD(fs,attack,decay,svalue,pvalue,fvalue)
% Žw’è‚ÌAttack‚ÆDecay‚ð”½‰f‚µ‚½M†‚ðo—Í‚·‚éŠÖ”

% if avalue>1.0 || avalue<0
%     error('avalue must be 0 to 1 double number');
% end
% if dvalue>1.0 || dvalue<0
%     error('dvalue must be 0 to 1 double number');
% end
% if svalue>1.0 || svalue<0
%     error('svalue must be 0 to 1 double number');
% end
% if rvalue>1.0 || rvalue<0
%     error('rvalue must be 0 to 1 double number');
% end

sig_a = linspace(avalue,dvalue,attack);
sig_d = linspace(dvalue,svalue,decay);
sig_s = linspace(svalue,svalue,sustain);
sig_r = linspace(svalue,rvalue,release);

adsr = [sig_a, sig_d, sig_s, sig_r];

end