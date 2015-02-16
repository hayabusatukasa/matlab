function sig_filt = medSgolayfilt(sig,coeff_sgolayfilt,coeff_medfilt)
% メディアンフィルタとsgolayfilterを用いた移動平均フィルタ
% Input:
%	sig			: 信号
% 	coeff_sgolayfilt: sgolayfiltの次数
%	coeff_medfilt	: メディアンフィルタの次数
%
% Output:
%	sig_filt	: フィルタを通過させた信号

sig_medfilt = medfilt1(sig,coeff_medfilt);
sig_filt = sgolayfilt(sig_medfilt,1,coeff_sgolayfilt);
end

