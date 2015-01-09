function audio_output = audioSampleGenerator_refactored...
    (audio_input,fs,tau,bpm,bars,beatperbar,noteunit,is_plot)
% �I�[�f�B�I�f�ނ����y�p�̃T���v���Ɏd�グ��֐�
% 14/12/10
%   audio_output�̒��������m�ł͂Ȃ��s��L�D
%   �s�[�N���������Ƃ�Ă��Ȃ��Ƃ��ɃG���[���b�Z�[�W�̂ݕ\�����ďo�͂�
%   �ǂ��ɂ����Ă��Ȃ��D
% 15/01/09
%   
%
% Input:
%     audio   : �I�[�f�B�I�f��(���m�����̂�)
%     fs      : �T���v�����O���g��
%     tau     : �ړ����σt�B���^�̃t���[����(in sec)
%     bpm     : 1��������̃r�[�g��(Beats per Minute)
%     bars    : ���ߐ�
%     beatperbar : 1���߂�����̔���
%     noteunit   : �P�ʉ��� (noteunit = 2^n)
%     is_plot : �s�[�N���o���ʂ��v���b�g���邩�ǂ��� (0:off else:on)

% audio_output�̕b�����擾
beat_interval = 60/bpm*(noteunit/beatperbar); % [sec]
aoBeats = bars*beatperbar;
bisample = round(beat_interval*fs); % [sample]
aoSampleLength = bisample*aoBeats; % [sample]

% audio_output�̕b�� > audio_input�̕b���̂Ƃ��C�G���[��Ԃ�
aiSampleLength = length(audio_input);
if aoSampleLength > aiSampleLength
    error('too short audio input');
end

% audio_input����G���x���[�v���擾
windowSize = round(fs*tau);
env = movingAverage(abs(audio_input),windowSize);
dsrate = 100;
envds = resample(env,1,dsrate);
envrs = interp(envds,dsrate);
env = envrs(1:length(env));

% �G���x���[�v����s�[�N���擾
thr = mean(env);
[~,locs_peak] = findpeaks(env,'MinPeakDistance',bisample,'MinPeakHeight',thr);

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

i_start = 1;
% j = 1;
% while (locs_valley(j)-windowSize) < 1
%     i_start = i_start + 1;
%     aoBeats = aoBeats + 1;
%     j = j + 1;
% end

audio_output = [];
if length(locs_peak)<aoBeats
    warning('Too short peaks. Return input audio.');
    audio_output = audio_input(1:aoSampleLength);
    return;
end

if (locs_valley(aoBeats)+bisample-1)>length(audio_input)
    warning('False to make audio sample. Return input audio.');
    audio_output = audio_input(1:aoSampleLength);
    return;
end

% ���o�����s�[�N���N�_�ɂ��āC�r�[�g���Ƃɉ����Ȃ����킹��
for i=i_start:aoBeats
    s_start = locs_valley(i);%-windowSize;
    s_end = s_start + bisample - 1;
    a_tmp = audio_input(s_start:s_end);
    audio_output = cat(1,audio_output,a_tmp);
    audio_plot(i,:) = a_tmp;
    s_start_plot(i) = s_start;
    s_end_plot(i) = s_end;
end

if is_plot ~= 0
    figure;
    subplot(2,1,1);
    t = linspace(0,length(audio_input)/fs,length(audio_input));
    hold on;
    plot(t,audio_input,'Color','b');
    for i=1:aoBeats
        plot(t(s_start_plot(i):s_end_plot(i)),audio_plot(i,:),'Color','r');
    end
    hold off;
    title('Audio used for generating');
    xlim([0 length(env)/fs]);
    xlabel('Time [s]');
    ylabel('Amplitude');

    
    t = linspace(0,length(env)/fs,length(env));
    subplot(2,1,2);
    plot(t,abs(audio_input)*0.25,'Color','b');
    hold on;
    plot(t,env,'Color','g');
    plot(locs_peak/fs,env(locs_peak),'rv','MarkerFaceColor','r');
    plot(locs_valley/fs,env(locs_valley),'rs','MarkerFaceColor','b');
    hold off;
    xlim([0 length(env)/fs]);
    title(['Audio Peak Picking tau=',num2str(tau)]);
    xlabel('Time [s]');
end

end

