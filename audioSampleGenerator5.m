function audio_output = audioSampleGenerator5...
    (audio_music,fs_music,audio_input,fs_input,ao_sec,contrast,min_speed,max_speed)
% audio_output = audioSampleGenerator...
%   (audio_input,fs,tau,bpm,bars,beatperbar,noteunit,is_plot)
% 音楽素材作成関数
%
% Input:
%     audio   : オーディオ素材(モノラルのみ)
%     fs      : サンプリング周波数
%     tau     : 移動平均フィルタのフレーム長(in sec)
%     bpm     : 1分あたりのビート数(Beats per Minute)
%     bars    : 小節数
%     beatperbar : 1小節あたりの拍数
%     noteunit   : 単位音符 (noteunit = 2^n)
%     is_plot : ピーク検出結果をプロットするかどうか (0:off else:on)
%
% Output:
%     audio_output : 音楽素材

% onsetの取得
ma1 = miraudio(audio_music,fs_music);
monset1 = mironsets(ma1,'Attack','Contrast',contrast);
onset1 = mirgetdata(monset1);

ma2 = miraudio(audio_input,fs_input);

% audio_inputの音量の小さい部分削減
mfr = mirframe(ma2,'Length',0.05,'s','Hop',1.0);
fr = mirgetdata(mfr);
pow = sum(abs(fr),1)/length(fr(:,1));
is_suffpow = pow > 0.05;
audio_tmp = fr(:,is_suffpow);
audio_input = reshape(audio_tmp,length(audio_tmp(1,:))*length(audio_tmp(:,1)),1);
ma2 = miraudio(audio_input,fs_input);

monset2 = mironsets(ma2,'Attack','Contrast',contrast);
onset2 = mirgetdata(monset2);

% onsetの秒からサンプル単位への変換
onset1_insamp = floor(onset1*fs_input);
onset2_insamp = floor(onset2*fs_input);



audio_output = zeros(1,ao_sec*fs_input);
% onset情報から入力音声の整列
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
        audio_output(ons1:ons2) = a_conv;
        n_ons1 = n_ons1+1;
        n_ons2 = n_ons2+1;
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