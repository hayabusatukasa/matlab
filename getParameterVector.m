function [vec_time,vec_param] = getParameterVector...
    (filename,deltaT,shiftT,fft_size,len_sec,paramtype)
% [vec_time,vec_param] = getParameterVector...
%	(filename,deltaT,shiftT,fft_size,len_sec)
% �����x�N�g���擾�֐�
%
% Input:
%	filename	: �����t�@�C����(.wav)
%	deltaT		: �t���[����(sec)
%	shiftT		: �t���[���V�t�g(sec)
%	fft_size	: FFT����(2^n)
%	len_sec		: �t�@�C���ǂݍ��݂̍ۂɕ������鎞�Ԓ�(default=60)
%	paramtype 	: �����x�N�g���̎��(default=1)
%
% Output:
%	vec_time	: ���ԃx�N�g��
%	vec_param 	: �����x�N�g��

if nargin<5
    len_sec = 60;
end
if nargin<6
    paramtype = 1;
end

% ���[�v�����ݒ�
a_info = audioinfo(filename);
dur = a_info.Duration;
i_stop = floor(dur/60);

vec_time = [];  % ���ԃx�N�g��
vec_param = []; % �����x�N�g��
% �p�����[�^�擾�S�̂ł̌v�Z���Ԃ̌v���J�n
t_total = cputime;
for i=0:i_stop
    % 1�����Ƃ̃p�����[�^�擾�̌v�Z���Ԃ̌v���J�n
    t_part = cputime;
    display(['calculating ',num2str(i),' to ',num2str(i+1)]);

    % 60�b���ƂɃp�����[�^�擾�֐��ɓ��邪�C�����ŃI�[�o�[���Ȃ��悤�ɂ���
    if floor(dur-i*len_sec)<=len_sec
        interval = floor(dur)-i*len_sec;
        s_start = i*len_sec;
        s_end = s_start+interval;
    else
        s_start = i*len_sec;
        s_end = (i+1)*len_sec+shiftT;
    end
    
    % �p�����[�^�擾���C�ꎞ�ϐ��Ɋi�[
    [t_time,t_vec] = getAcousticParameter...
        (filename,s_start,s_end,deltaT,shiftT,fft_size,paramtype);
    
    % �ꎞ�ϐ�������
    vec_time = cat(1,vec_time,t_time);
    vec_param = cat(1,vec_param,t_vec);
    
    % 1�����Ƃ̃p�����[�^�擾�̌v�Z���Ԃ̌v���I��
    t_part = cputime - t_part;
    display(['�v�Z���Ԃ� ',num2str(t_part),' �b�ł�']);
end
% �p�����[�^�擾�S�̂ł̌v�Z���Ԃ̌v���I��
t_total = cputime - t_total;
display(['�g�[�^���̌v�Z���Ԃ� ',num2str(t_total),' �b�ł�']);

end
