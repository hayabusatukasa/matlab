function [T_scene,sf] = cutScene...
    (vec_time,vec_score,windowSize,coeff_medfilt,filtertype,dsrate,is_plot)
% [T_scene,sf] = cutScene...
%   (vec_time,vec_score,windowSize,coeff_medfilt,filtertype,dsrate,is_plot)
% ��ʂ̕���_�����o���C��ʂ𐶐�����֐�
% 
% Input:
%	vec_time		: ���ԃx�N�g�� 
%	vec_param		: �����x�N�g��
%   windowSize 		: �ړ����σt�B���^�̃^�b�v��
%   coeff_medfilt 	: ���f�B�A���t�B���^�[�̎���(filtertype=1�̂Ƃ��͖������Ă悢)
%   filtertype		: �p����ړ����σt�B���^�̎��(1:basic 2:medSgolayfilter)
%   dsrate		 	: �_�E���T���v�����O���[�g
%   is_plot			: ���ʂ��v���b�g���邩�ǂ���
% Output:
%   T_scene 		: ��ʂ̃e�[�u��
%   sf 				: �t�B���^��ʉ߂������X�R�A

% �ړ����σt�B���^�̓K�p
if filtertype == 1 % basic moving average
    sf = movingAverage(vec_score,windowSize);
elseif filtertype == 2 % sgolayfilter and medianfilter
    coeff_sgolayfilt = windowSize;
    sf = medSgolayfilt(vec_score,coeff_sgolayfilt,coeff_medfilt);
end

% ���������ꂽ�M���̃_�E���T���v�����O
% dsrate = 120; % �_�E���T���v�����O���[�g
sfds = downsample(sf,dsrate);

% �_�E���T���v�����O���ꂽ�M���̋ɏ��l�̒��o
[~,locs_valley_sfds] = getPeakValley(sfds,1,-Inf,-Inf,0,0,0);

% ����ꂽ�ɏ��l���猳�̃T���v�����O���[�g�ł̈ʒu���Ƃ�C��ʂ����o
usrate = dsrate; % �A�b�v�T���v�����O���[�g
sfrs = interp(sfds,usrate);
sfrs = sfrs(1:length(sf));
locs_valley_us = locs_valley_sfds * usrate - usrate;
scene_start(1) = vec_time(1);
scene_end(1) = vec_time(locs_valley_us(1));
if length(locs_valley_sfds)>1
    for i=2:length(locs_valley_sfds)
        scene_start(i) = vec_time(locs_valley_us(i-1));
        scene_end(i) = vec_time(locs_valley_us(i));
    end
    scene_start(i+1) = vec_time(locs_valley_us(i));
    scene_end(i+1) = vec_time(length(sf));
end

% �e�[�u���쐬
T_scene = table(scene_start',scene_end','VariableNames',...
    {'scene_start','scene_end'});

if is_plot==1
    t = linspace(vec_time(1),vec_time(end),length(vec_time));
    
    figure;
    plot(t,vec_score.*(mean(sfrs)/max(vec_score))); 
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
