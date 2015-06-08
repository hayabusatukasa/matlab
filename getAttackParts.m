function [locs_peak,locs_valley] = ...
    getAttackParts(sig,mpd,mph_peak,mph_valley,thr,is_removeTrend,is_plot)
% function [locs_peak,locs_valley] = ...
%   getPeakValley(sig,mpd,mph_peak,mph_valley,thr,is_removeTrend,is_plot)
%
% �^����ꂽ�M������s�[�N�Ƌɏ��l���擾����֐�
% 
% Input:
%	sig			: ���͐M��
% 	mpd			: MinPeakDistance(default=1)
% 	mph_peak	: MinPeakHeight(for peak, default=-Inf)
% 	mph_valley	: MinPeakHeight(for valley, default=-Inf)
% 	thr			: Threshold(default=0)
% 	is_removeTrend: �g�����h�������邩�ǂ���(0 or 1, default=0)
% 	is_plot		: �v���b�g���邩�ǂ���(0 or 1, default=1)
% 
% Output:
%	locs_peak	: �s�[�N�ʒu
%	locs_valley : �ɏ��_�ʒu

if nargin<2; mpd = 1; end;
if nargin<3; mph_peak = -Inf; end;
if nargin<4; mph_valley = -Inf; end;
if nargin<5; thr = 0; end;
if nargin<6; is_removeTrend = 0; end;
if nargin<7; is_plot = 1; end;

sig_orig = sig;
% �M���̃g�����h����
if is_removeTrend == 1
    [p,s,mu] = polyfit((1:numel(sig))',sig,10);
    f_y = polyval(p,(1:numel(sig))',[],mu);
    sig = sig - f_y;
end

% �s�[�N�����̎擾
thr = mean(env);
%[~,~,~,thr,~] =  quantile(env);
[~,locs_peak] = findpeaks...
    (env,'MinPeakDistance',mpd,'MinPeakHeight',mph,'Npeaks',aoBeats);

% �s�[�N���Ƃɒ��O�̋ɏ��_���擾
for i=1:length(locs_peak)      
    % �����Ă���s�[�N����1�O�̃s�[�N�܂ł̋�Ԃ̃G���x���[�v���擾���C
    % ����𔽓]������
    if i>1
        locs = (locs_peak(i-1)+1):locs_peak(i);
    else
        locs = 1:locs_peak(i);
    end
    env_rev = flipud(env(locs));
    
    % ���]�������G���x���[�v����C�s�[�N�̒��O��1�����ɏ��_���擾
    env_rev_inverted = (-env_rev);
    thr = mean(env_rev_inverted);
    [~,locs_rev] = findpeaks(env_rev_inverted,...
        'NPeaks',1,'MinPeakHeight',thr,'Threshold',0);
    
    if isempty(locs_rev) == 0
        locs_valley(i) = locs_peak(i) - locs_rev;
    else % �ɏ��_�����Ȃ������Ƃ��C�s�[�N��0.01�b�O���ɏ��_�Ƃ���
        warning(['in ',num2str(i),'th peak: not found valley']);
        if locs_peak(i) > floor(fs/100)
            locs_valley(i) = locs_peak(i) - floor(fs/100);
        else 
            locs_valley(i) = 1;
        end
    end
end

if is_plot == 1
    t = 1:length(sig);
    figure;
    if is_removeTrend == 1
        subplot(3,1,1);
        plot(t,sig_orig); grid on; title('Original Signal'); 
        xlim([0,length(t)]);
        subplot(3,1,2);
        plot(t,sig); grid on; title('Signal Removed Trend');
        xlim([0,length(t)]);
        subplot(3,1,3);
        hold on;
        plot(t,sig);
        plot(locs_peak,sig(locs_peak),'rv','MarkerFaceColor','r');
        plot(locs_valley,sig(locs_valley),'rs','MarkerFaceColor','b');
        hold off;
        grid on; title('Peaks and Valleys');
        xlim([1,length(t)]);
    else
        subplot(2,1,1);
        plot(t,sig); grid on; title('Signal'); xlim([0,length(t)]);
        subplot(2,1,2);
        hold on;
        plot(t,sig);
        plot(locs_peak,sig(locs_peak),'rv','MarkerFaceColor','r');
        plot(locs_valley,sig(locs_valley),'rs','MarkerFaceColor','b');
        hold off;
        grid on; title('Peaks and Valleys');
        xlim([1,length(t)]);
    end
end
end

