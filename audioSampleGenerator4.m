function audio_output = audioSampleGenerator4(music_fname,audio_input,fs,tau)
% audio_output = audioSampleGenerator...
%   (audio_input,fs,tau,bpm,bars,beatperbar,noteunit,is_plot)
% ���y�f�ލ쐬�֐�
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
%
% Output:
%     audio_output : ���y�f��

% ���y�����擾
ma = miraudio(music_fname);
mtempo = mirtempo(ma);
tempo = mirgetdata(mtempo);
beat_interval = 60/tempo;

[mu,fs_music] = audioread(music_fname);

windowSize = round(fs_music*tau);
env = movingAverage(abs(mu),windowSize);
dsrate = 100;
envds = resample(env,1,dsrate);
envrs = interp(envds,dsrate);
env = envrs(1:length(env));

thr = mean(env);
[onset1,~] = getPeakValley(env,floor(beat_interval*fs_music),thr,-thr,0,0,0);
% monset = mironsets(mpeak)
% onset = mirgetdata(monset);

% % 
% ma = miraudio(audio_input,fs);
% monset = mironsets(ma,'Contrast',beat_interval)
% locs_valley = mirgetdata(monset);
% if length(onset) > length(locs_valley)
%     error('Too many onsets');
% end

% audio_input����G���x���[�v���擾
windowSize = round(fs*tau);
env = movingAverage(abs(audio_input),windowSize);
dsrate = 100;
envds = resample(env,1,dsrate);
envrs = interp(envds,dsrate);
env = envrs(1:length(env));

% �G���x���[�v����s�[�N���擾
thr = mean(env);
[onset2,~] = getPeakValley(env,floor(beat_interval*fs),thr,-thr,0,0,0);

% ���y��onset����
m_info = audioinfo(music_fname);
onset1 = onset1*(fs/fs_music);
%locs_valley = floor(locs_valley*fs);
audio_output = zeros(1,floor(m_info.Duration*fs));
n_ons1 = 1;
n_ons2 = 1;
ons1 = onset1(n_ons1);
ons2 = onset1(n_ons1+1)-1;
ons2ons12 = ons2 - ons1 + 1;
ons3 = onset2(n_ons2);
ons4 = onset2(n_ons2+1)-1;
ons2ons34 = ons4-ons3+1;
ratio = ons2ons34/ons2ons12;
while 1
    disp([num2str(n_ons1),'/',num2str(length(onset1))]);
    if 1.0 < ratio && ratio < 1.8
        a_org = audio_input(ons3:ons4);
        a_conv = ConvertAudioSpeed(a_org,fs,ons2ons12);
        audio_output(ons1:ons2) = a_conv;
        n_ons1 = n_ons1+1;
        n_ons2 = n_ons2+1;
        if n_ons1+1 > length(onset1) || n_ons2+1 > length(onset2)
            break;
        end
        ons1 = onset1(n_ons1);
        ons2 = onset1(n_ons1+1)-1;
        ons2ons12 = ons2 - ons1 + 1;
        ons3 = onset2(n_ons2);
        ons4 = onset2(n_ons2+1)-1;
        ons2ons34 = ons4-ons3+1;
        ratio = ons2ons34/ons2ons12;
    elseif ratio >= 1.8
        n_ons1 = n_ons1+1;
        if n_ons1+1 > length(onset1)
            a_org = audio_input(ons3:ons4);
            a_conv = ConvertAudioSpeed(a_org,fs,ons2ons12);
            audio_output(ons1:ons2) = a_conv;
            break;
        end
        ons2 = onset1(n_ons1+1)-1;
        ons2ons12 = ons2 - ons1 + 1;
        ratio = ons2ons34/ons2ons12;
    elseif 1.0 >= ratio
        n_ons2 = n_ons2 + 1;
        if n_ons2+1 > length(onset2)
            a_org = audio_input(ons3:ons4);
            a_conv = ConvertAudioSpeed(a_org,fs,ons2ons12);
            audio_output(ons1:ons2) = a_conv;
            break;
        end
        ons4 = onset2(n_ons2+1)-1;
        ons2ons34 = ons4-ons3+1;
        ratio = ons2ons34/ons2ons12;
    end
end

end