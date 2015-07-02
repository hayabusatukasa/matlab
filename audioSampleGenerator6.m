function audio_output = audioSampleGenerator6...
    (bpm,beatperbar,noteunit,audio_input,fs_input,ao_sec,tau,contrast,...
    min_speed,max_speed)
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

% onset�̎擾
% ma1 = miraudio(audio_music,fs_music);
% menv1 = mirenvelope(ma1,'Tau',tau);
% monset1 = mironsets(menv1,'Attack','Contrast',contrast);
% onset1 = mirgetdata(monset1);
% st = onset1(1);
% mtempo = mirtempo(ma1);
% bpm = mirgetdata(mtempo);
% beatperbar = 4;
% noteunit = 4;
beat_interval = 60/bpm*(noteunit/beatperbar); % [sec]
onset1 = zeros(1,1000);
for i=1:1000
    onset1(i) = i*beat_interval;
end

ma2 = miraudio(audio_input,fs_input);

% audio_input�̉��ʂ̏����������팸
mfr = mirframe(ma2,'Length',0.05,'s','Hop',1.0);
fr = mirgetdata(mfr);
pow = sum(abs(fr),1)/length(fr(:,1));
is_suffpow = pow > 0.025;
audio_tmp = fr(:,is_suffpow);
audio_tmp = reshape(audio_tmp,length(audio_tmp(1,:))*length(audio_tmp(:,1)),1);
if (length(audio_tmp)/fs_input) > ao_sec
    audio_input = audio_tmp;
    ma2 = miraudio(audio_input,fs_input);
else
    % �������Ȃ�
end

menv2 = mirenvelope(ma2,'Tau',tau);
monset2 = mironsets(menv2,'Attack','Contrast',contrast);
onset2 = mirgetdata(monset2);

% onset2��2��菭�Ȃ��Ƃ��Caudio_input��؂����ĕԂ�
if numel(onset2)<2
    warning('less onsets: return raw audio');
    audio_output = audio_input(1:(fs_input*ao_sec));
    return;
end

% onset�̕b����T���v���P�ʂւ̕ϊ�
onset1_insamp = [1,floor(onset1*fs_input)];
onset2_insamp = [1;floor(onset2*fs_input)];

audio_output = zeros(1,ao_sec*fs_input);
% onset��񂩂���͉����̐���
n_ons1 = 1;
n_ons2 = 1;
ons1 = onset1_insamp(n_ons1);
ons2 = onset1_insamp(n_ons1+1)-1;
ons2ons12 = ons2 - ons1 + 1;
ons3 = onset2_insamp(n_ons2);
ons4 = onset2_insamp(n_ons2+1)-1;
ons2ons34 = ons4-ons3+1;
ratio = ons2ons34/ons2ons12;

while 1
    disp([num2str(n_ons1),'/',num2str(length(onset1_insamp))]);
    if min_speed < ratio && ratio < max_speed
        a_org = audio_input(ons3:ons4);
        a_conv = ConvertAudioSpeed(a_org,fs_input,ons2ons12);
        
        % ���Y������
        decay = floor(length(a_conv)/2)-10;
        sustain = ceil(length(a_conv)/2)-10;
        envelope = getADSR(10,decay,sustain,10,0,1.0,0.5,0)';
        a_conv = a_conv.*envelope;
        
        audio_output(ons1:ons2) = a_conv;
        n_ons1 = n_ons1+1;
        n_ons2 = n_ons2+1;
        if length(audio_output) > ao_sec*fs_input
            audio_output = audio_output(1:fs_input*ao_sec);
            break;
        end
        if n_ons1+1 > length(onset1_insamp) || n_ons2+1 > length(onset2_insamp)
            break;
        end
        ons1 = onset1_insamp(n_ons1);
        ons2 = onset1_insamp(n_ons1+1)-1;
        ons2ons12 = ons2 - ons1 + 1;
        ons3 = onset2_insamp(n_ons2);
        ons4 = onset2_insamp(n_ons2+1)-1;
        ons2ons34 = ons4-ons3+1;
        ratio = ons2ons34/ons2ons12;
    elseif ratio >= max_speed
        n_ons1 = n_ons1+1;
        if n_ons1+1 > length(onset1_insamp)
            a_org = audio_input(ons3:ons4);
            a_conv = ConvertAudioSpeed(a_org,fs_input,ons2ons12);
            audio_output(ons1:ons2) = a_conv;
            break;
        end
        ons2 = onset1_insamp(n_ons1+1)-1;
        ons2ons12 = ons2 - ons1 + 1;
        ratio = ons2ons34/ons2ons12;
    elseif min_speed >= ratio
        n_ons2 = n_ons2 + 1;
        if n_ons2+1 > length(onset2_insamp)
            a_org = audio_input(ons3:ons4);
            a_conv = ConvertAudioSpeed(a_org,fs_input,ons2ons12);
            audio_output(ons1:ons2) = a_conv;
            break;
        end
        ons4 = onset2_insamp(n_ons2+1)-1;
        ons2ons34 = ons4-ons3+1;
        ratio = ons2ons34/ons2ons12;
    end
end

end