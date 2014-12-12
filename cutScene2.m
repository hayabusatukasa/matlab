function [T_scene,score_filtered,thsld_hi,thsld_low] = cutScene2...
    (time,score,windowSize,coeff_medfilt,filtertype,is_scenebind,is_plot)
% ver2 臒l�̎�������

switch nargin
    case 2
        windowSize = 30;
        coeff_medfilt = 1;
        filtertype = 1;
        is_scenebind = 1;
        is_plot = 0;
    case 3
        coeff_medfilt = 1;
        filtertype = 1;
        is_scenebind = 1;
        is_plot = 0;
    case 4
        filtertype = 1;
        is_scenebind = 1;
        is_plot = 0;
    case 5
        is_scenebind = 1;
        is_plot = 0;
    case 6
        is_plot = 0;
    otherwise
        
end
        
% �ړ����σt�B���^�̓K�p
if filtertype == 1 % basic moving average
    coeff = ones(1,windowSize)/windowSize;
    score_filtered = filter(coeff,1,score);
elseif filtertype == 2 % sgolayfilter and medianfilter
    coeff_sgolayfilt = windowSize;
    % coeff_medfilt = 5;
    score_filtered = medSgolayfilt(score,coeff_sgolayfilt,coeff_medfilt);
end

% 臒l�̌���
[thsld_hi,thsld_low] = detectThreshold(score_filtered,0,0);

% 臒l����̘_���l�x�N�g���̐���
score_filtered_upperthsld1 = ...
    score_filtered((windowSize+1):end) > thsld_low;
score_filtered_lowerthsld2 = ...
    score_filtered((windowSize+1):end) < thsld_hi;

% ��ʐ؂�o�����[�v
t = time((windowSize+1):end);
scene_start = 0;
scene_end = [];
scene_num = 1;
len_scene_start = length(scene_start);
len_scene_end = length(scene_end);
for i=2:length(t)   
    is_scene_end = ...
        score_filtered_upperthsld1(i-1) - score_filtered_upperthsld1(i); 
    is_scene_start = ...
        score_filtered_lowerthsld2(i-1) - score_filtered_lowerthsld2(i);
  
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

% �Z���Ƃ肷������ʂ�אڂ����ʂƌ�������
if is_scenebind==1
    thr_scenelength = 100;
    [scene_start,scene_end,scene_num] = ...
        sceneBind(scene_start,scene_end,scene_num,thr_scenelength);
end

% make table
T_scene = table(scene_start',scene_end','VariableNames',...
    {'scene_start','scene_end'});

% plot score_filtered and threshold line
if is_plot==1
    figure;
    plot(t,score_filtered((windowSize+1):end)); hold all;...
        plot(t,linspace(thsld_low,thsld_low,length(t)));...
        plot(t,linspace(thsld_hi,thsld_hi,length(t))); hold off;
    xlim([0,t(end)]);
end
end