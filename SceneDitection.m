function T_scene = SceneDitection(filename,is_plot,ditect_type,wg_length,thr_dist)
% �����t�@�C�������ʂ��擾����֐�
% T_scene = SceneDitection(filename,is_plot,ditect_type,wg_length,thr_dist)
% Inputs
%     filename    : �I�[�f�B�I�t�@�C����
%     is_plot     : ��ʌ��o���ʂ�\�����邩�ǂ���[0:No(default) 1:Yes]
%     ditect_type : ��ʌ�⏈���̕��@
%                   [0:�X�R�A�Z�o�ƈړ����σt�B���^����(default) 
%                    other:�ɏ���ʌ��̐���]
%     wg_length   : �d�ݕt���̊�ƂȂ��ʂ̎��Ԓ��i�b�j[default:60]
%     thr_dist    : ��ʂ����������p�����[�^�����̂������l[default:1.0]
% Outputs
%     T_scene     : ��ʊJ�n�n�_�ƏI���n�_�̃e�[�u���i�b�j
%

%% �����ݒ�
if nargin<2; is_plot=0; end
if nargin<3; ditect_type=0; end
if nargin<4; wg_length=60; end
if nargin<5; thr_dist=1.0; end

%% �����x�N�g���擾
deltaT = 1.0;   % �t���[������\
shiftT = 0.5;   % �t���[���V�t�g��
fft_size = 2^15;% FFT�T�C�Y
len_sec = 60;   % �����t�@�C���𕪊����鎞�Ԓ�
paramtype = 1;  % ��ʌ��o�p�̃p�����[�^

[vec_time,vec_param] = ...
    getParameterVector(filename,deltaT,shiftT,fft_size,len_sec,paramtype);

%% ��ʌ��̍쐬
if ditect_type==0
    % �_����쐬
    feedback = 10;      % �_�������߂��ƂȂ�t���[����
    type_getscore = 1;  % �_���̌v�Z���@
    [~,vec_score] = calcScore(vec_time,vec_param,feedback,type_getscore);
    
    % ��ʂ̕���_���o�ɂ��ꎞ�I�ȏ�ʌ��̌��o
    windowSize = 10;    % �ړ����σt�B���^�̃^�b�v��
    dsrate = 10;        % ����̃_�E���T���v�����O���[�g
    coeff_medfilt = 10; % ���f�B�A���t�B���^�̃^�b�v��
    filtertype = 1;     % �t�B���^�̎�ށi1:�ړ����σt�B���^�C2:sgolaymedian�t�B���^�j
    [T_tmpscene,~] = cutScene...
        (vec_time,vec_score,windowSize,coeff_medfilt,filtertype,dsrate,0);
else
    % �����̋ψ�ȒZ����ʌ����쐬
    T_tmpscene = splitScene(vec_time,2);
end

%% �ގ���ʂ̌���
%wg_length = 60; % �d�ݕt�����Ȃ�����ʂ̒���
%thr_dist = 1.0; % ��ʂ𕪊����鋗���̂������l
T_scene = sceneBind(vec_time,vec_param,T_tmpscene,thr_dist,wg_length);
display([num2str(height(T_scene)),' scenes returned sceneBind']);
T_scene.scene_start = floor(T_scene.scene_start);
T_scene.scene_end = floor(T_scene.scene_end);
if is_plot==1
    viewScenes(vec_param,T_scene,length(vec_param(1,:)));
end

end