function [T_scene,sf] = cutScene3...
    (T_param,windowSize,coeff_medfilt,filtertype,dsrate,is_plot)
% [T_scene,sf] = cutScene3...
%   (T_param,windowSize,coeff_medfilt,filtertype,dsrate,is_plot)
% ��ʂ̕���_�����o���C��ʂ𐶐�����֐�
% ver3 �ɏ��l�����ʂ̓]���_�����o����
% 
% Input:
%   T_param : �����p�����[�^�ƃX�R�A�̃e�[�u��
%   windowSize : �ړ����σt�B���^�̃^�b�v��
%   coeff_medfilt : ���f�B�A���t�B���^�[�̎���(filtertype=1�̂Ƃ��͖������Ă悢)
%   filtertype : �p����ړ����σt�B���^�̎��(1:basic 2:medSgolayfilter)
%   dsrate : �_�E���T���v�����O���[�g
%   is_plot : ���ʂ��v���b�g���邩�ǂ���
% Output:
%   T_scene : ��ʂ̃e�[�u��
%   sf : �t�B���^��ʉ߂������X�R�A
     
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
sfds = downsample(sf,dsrate);

% �_�E���T���v�����O���ꂽ�M���̋ɏ��l�̒��o
[~,locs_valley_sfds] = getPeakValley(sfds,1,-Inf,-Inf,0,0,0);

% ����ꂽ�ɏ��l���猳�̃T���v�����O���[�g�ł̈ʒu���Ƃ�C��ʂ����o
usrate = dsrate; %floor(length(sf)/length(sfds)); % �A�b�v�T���v�����O���[�g
sfrs = interp(sfds,usrate);
sfrs = sfrs(1:length(sf));
locs_valley_us = locs_valley_sfds * usrate - usrate;
scene_start(1) = time(1);
scene_end(1) = time(locs_valley_us(1));
if length(locs_valley_sfds)>1
    for i=2:length(locs_valley_sfds)
        scene_start(i) = time(locs_valley_us(i-1));
        scene_end(i) = time(locs_valley_us(i));
    end
    scene_start(i+1) = time(locs_valley_us(i));
    scene_end(i+1) = time(length(sf));
end

% �e�[�u���쐬
T_scene = table(scene_start',scene_end','VariableNames',...
    {'scene_start','scene_end'});

if is_plot==1
    t = linspace(time(1),time(end),length(time));
    
    figure;
    plot(t,score.*(mean(sfrs)/max(score))); 
    hold all;
    plot(t,sfrs,'Color','g');
    stem(t(locs_valley_us),sfrs(locs_valley_us),'Color','r');
    hold off;
    title(['MovingAverageFrameLength= ',num2str(windowSize),' DownsamplingRate = ',num2str(dsrate)]);
    xlabel('Time [s]');
    ylabel('Score');
    %legend('Moving average','Downsample','Valley');
    xlim([t(1),t(end)]);
end
end