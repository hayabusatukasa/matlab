function [T_scene,sf] = cutScene3...
    (T_param,windowSize,coeff_medfilt,filtertype,dsrate,is_plot)
% 
%
% ver3 �ɏ��l�����ʂ̓]���_�����o����
     
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

% �Z���Ƃ肷������ʂ�אڂ����ʂƌ�������
% if is_scenebind==1
%     [T_scene,d] = sceneBind4(T_param,T_scene,1.0);
% end
% 
% if is_scenebind==2
%     [T_scene,d] = sceneBind3(T_param,T_scene,10);
% end

if is_plot==1
    figure;
    plot(sf); hold all;
    plot(sfrs);
    stem(locs_valley_us,sfrs(locs_valley_us));
    hold off;
    title(['Moving Average FrameLength= ',num2str(windowSize),' DownsamplingRate = ',num2str(dsrate)]);
    xlabel('Sample');
    legend('Moving average','Downsample','Valley');
end
end