function [T_scene,sf] = cutScene3...
    (time,score,windowSize,coeff_medfilt,filtertype,is_scenebind)
% ver3 �ɏ��l�����ʂ̓]���_�����o����
        
% �ړ����σt�B���^�̓K�p
if filtertype == 1 % basic moving average
    sf = movingAverage(score,windowSize);
elseif filtertype == 2 % sgolayfilter and medianfilter
    coeff_sgolayfilt = windowSize;
    % coeff_medfilt = 5;
    sf = medSgolayfilt(score,coeff_sgolayfilt,coeff_medfilt);
end

% ���������ꂽ�M���̃_�E���T���v�����O
dsrate = 120; % �_�E���T���v�����O���[�g
sfds = resample(sf,1,dsrate);

% �s�[�N,�ɏ��l�̒��o
[locs_peak_sfds,locs_valley_sfds] = getPeakValley(sfds,1,-Inf,-Inf,0,0,0);

usrate = floor(length(sf)/length(sfds)); % �A�b�v�T���v�����O���[�g
scene_start(1) = time(1);
scene_end(1) = time(locs_valley_sfds(1)*usrate);
if length(locs_valley_sfds)>1
    for i=2:length(locs_valley_sfds)
        scene_start(i) = time(locs_valley_sfds(i-1)*usrate);
        scene_end(i) = time(locs_valley_sfds(i)*usrate);
    end
    scene_start(i+1) = time(locs_valley_sfds(i)*usrate);
    scene_end(i+1) = time(length(sfds)*usrate);
end

% �Z���Ƃ肷������ʂ�אڂ����ʂƌ�������
if is_scenebind==1
    method = 1;
    thr = 200;
    [scene_start,scene_end,scene_num] = ...
        sceneBind(scene_start,scene_end,method,thr);
end

% make table
T_scene = table(scene_start',scene_end','VariableNames',...
    {'scene_start','scene_end'});
