function S = sharpness(BarkAxis,N_specif,N_tot)
% sharpness���v�Z����֐�
%     BarkAxis    : Bark���̔z��
%     N_specif    : Bark�ɑ΂��Ẵ��E�h�l�X
%     N_tot       : ���E�h�l�X�ʐ�

% �v�Z��@�͎��̘_�����Q�l�ɂ��Ă���
% - 
% �l�ɗD�����Ɠd���i�⎩���ԂȂǂ̉����f�U�C���Ɋւ��錤��
% �� ���i�L���Z�p�Ȋw��w�j

w = zeros(1,length(BarkAxis));  % �d�݂̏�����

% ���S�o���h1000Hz�C�o���h��160Hz�̃t�B���^�[��ʉ߂�����
% �z���C�g�m�C�Y�ŃV���[�v�l�X��1�ƂȂ�悤�Ȓ萔
C = 1/91.6582;   

% �d�݂̌v�Z
for i=1:length(BarkAxis)
    w(i) = sharpness_weight(BarkAxis(i));
end

numerator = N_specif.*w.*BarkAxis;
S = C * sum(numerator) / N_tot;
end