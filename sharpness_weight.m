function result = sharpness_weight(z)
% sharpness�̏d�݌W�����v�Z����֐�
% �v�Z��@�͎��̘_�����Q�l�ɂ��Ă���
% - 
% �l�ɗD�����Ɠd���i�⎩���ԂȂǂ̉����f�U�C���Ɋւ��錤��
% �� ���i�L���Z�p�Ȋw��w�j
if z < 14
    result =  1;
else
    result = 0.00012*z*z*z*z - 0.0056*z*z*z + 0.1*z*z - 0.81*z + 3.51;
end
end