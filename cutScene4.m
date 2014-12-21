function [T_scene,sf,thsld_hi,thsld_low] = cutScene4...
    (T_param,windowSize,coeff_medfilt,filtertype,dsrate,is_scenebind,is_plot)
% 
%
% ver4 �_�E���T���v�����O��p����臒l�ɂ�錈��
     
time = T_param.time;
score = T_param.score;

% �ړ����σt�B���^�̓K�p
if filtertype == 1 % basic moving average
    sf = movingAverage(score,windowSize);
elseif filtertype == 2 % sgolayfilter and medianfilter
    coeff_sgolayfilt = windowSize;
    % coeff_medfilt = 5;
    sf = medSgolayfilt(score,coeff_sgolayfilt,coeff_medfilt);
end

% ���������ꂽ�M���̃_�E���T���v�����O
% dsrate = 120; % �_�E���T���v�����O���[�g
sfds = resample(sf,1,dsrate);

% 臒l�̌���
[thsld_hi,thsld_low] = detectThreshold2(sfds,1,2,0,1);

% �_�E���T���v�����O�����M�������̃T���v�������O���[�g�ɕϊ�
sfrs = interp(sfds,dsrate);
sfrs = sfrs(1:length(sf));

% 臒l����̘_���l�x�N�g���̐���
sfrs_upperthsldlow = sfrs > thsld_low;
sfrs_lowerthsldhi =  sfrs < thsld_hi;

% ��ʐ؂�o�����[�v
t = time;
scene_start = 0;
scene_end = [];
scene_num = 1;
len_scene_start = length(scene_start);
len_scene_end = length(scene_end);
for i=2:length(t)
    is_scene_end = sfrs_upperthsldlow(i-1)...
                 - sfrs_upperthsldlow(i); 
    is_scene_start = sfrs_lowerthsldhi(i-1)...
                   - sfrs_lowerthsldhi(i);
  
    if is_scene_end == 1
        % ��ʂ̏I��肪���܂��ĂȂ��Ƃ����߂�
        if len_scene_start ~= len_scene_end
            scene_end(scene_num) = t(i);
            scene_num = scene_num+1;
            len_scene_end = length(scene_end);
        end
    elseif is_scene_start == 1
        % ��ʂ̎n�܂肪���܂��ĂȂ��Ƃ����߂�
        if len_scene_start == len_scene_end
            scene_start(scene_num) = t(i);
            len_scene_start = length(scene_start);
        end
    else
        % nothing to do
    end
end
if len_scene_start ~= len_scene_end
    scene_end(scene_num) = t(end);
end

% �e�[�u���쐬
T_scene = table(scene_start',scene_end','VariableNames',...
    {'scene_start','scene_end'});

% �Z���Ƃ肷������ʂ�אڂ����ʂƌ�������
if is_scenebind==1
    T_scene = sceneBind3(T_param,T_scene,10);
end

if is_plot==1
    figure;
    plot(t,sf); hold all;
    plot(t,sfrs);
    plot(t,linspace(thsld_low,thsld_low,length(t)));
    plot(t,linspace(thsld_hi,thsld_hi,length(t))); hold off;
    xlim([0,t(end)]);
end
end