function sig_filt = medSgolayfilt(sig,coeff_sgolayfilt,coeff_medfilt)
sig_medfilt = medfilt1(sig,coeff_medfilt);
sig_filt = sgolayfilt(sig_medfilt,1,coeff_sgolayfilt);
end

