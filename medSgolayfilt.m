function sig_filt = medSgolayfilt(sig,coeff_sgolayfilt,coeff_medfilt)
% ���f�B�A���t�B���^��sgolayfilter��p�����ړ����σt�B���^
% Input:
%	sig			: �M��
% 	coeff_sgolayfilt: sgolayfilt�̎���
%	coeff_medfilt	: ���f�B�A���t�B���^�̎���
%
% Output:
%	sig_filt	: �t�B���^��ʉ߂������M��

sig_medfilt = medfilt1(sig,coeff_medfilt);
sig_filt = sgolayfilt(sig_medfilt,1,coeff_sgolayfilt);
end

