function [N_specif,wstruct] = ohoge(filename,s_start,s_end)
%% �O����
audio_info = audioinfo(filename);
fs = audio_info.SampleRate;
audio = audioread(filename, [s_start*fs+1,s_end*fs]);
if audio_info.NumChannels > 1
    audio = (audio(:,1)+audio(:,2))/2;
end

% N_tot     : total loudness, in sone
% N_specif  : specific loudness, in sone/bark
% BarkAxis  : vector of Bark band numbers used for N_specif computation
% LN        : loudness level,in phon
deltaT = 1.0;   % length of the signal in sec
shiftT = 0.5;   % shift length in sec
P0 = 2e-5;      % sound pressure level reference in Pa
N_tot = []; N_specif = []; LN = []; 
N_time = [];
j = 1;
deltaS = fs * deltaT;
shiftS = fs * shiftT;
endS = length(audio)-deltaS;

%% calculate loudness
for i=0:shiftS:endS
    VectNiv30ct = gene_ThirdOctave_levels(audio(i+1:i+deltaS),fs,deltaT,P0);
    VectNiv30ct = VectNiv30ct(1:28,:);
    VectNiv30ct = VectNiv30ct(:);
    VectNiv30ct(VectNiv30ct < -60) = -60;
    [N_tot(j),N_specif(j,:),BarkAxis,LN(j)] = Loudness_ISO532B(VectNiv30ct);
    N_time(j,1) = s_start + (j-1)*shiftT;
    N_time(j,2) = N_time(j,1) + deltaT;
    j = j + 1;
end

%% get various parameters from loudness
nelem = numel(N_specif(:,1));
for i=1:nelem
    for j=1:24
        N_specif_tmp(j,:) = N_specif(i,(j-1)*10+1:(j-1)*10+10);
    end
    wstruct.N_specif(i).ary = N_specif_tmp;
end
wstruct.time = N_time;  % �t���[���̋��
wstruct.total = N_tot;  % ���E�h�l�X�̖ʐ�
wstruct.LN = LN;        % ���E�h�l�X���x��
for i=1:nelem
    % ���E�h�l�X���x��24�ɕ������Ă��ꂼ��̖ʐς����߂�
    wstruct.mean(i,:) = mean(wstruct.N_specif(i).ary');
    % ���E�h�l�X���x����ɑ�_��2������
    clear tmp;
    [~,tmp] = findpeaks(N_specif(i,:),'NPEAKS',2,'SORTSTR','descend');
    if length(tmp) < 2
        if length(tmp) < 1
            tmp = 0;
        end
        tmp(2) = 0;
    end
    wstruct.peak1(i) = tmp(1)/10;
    wstruct.peak2(i) = tmp(2)/10;
    % �V���[�v�l�X�̎Z�o
    wstruct.sharp(i) = sharpness(BarkAxis,N_specif(i,:),N_tot(i));
end

%% write csv file
clear tmp;
% tmp = horzcat(N_time(:,1),wstruct.mean);
% tmp = cat(1,[0:24],tmp);
T = table(wstruct.time(:,1),wstruct.LN',wstruct.sharp',...
     wstruct.peak1',wstruct.peak2','VariableNames',...
     {'Time','LN','Sharpness','Peak1','Peak2'});
wPass = 'C:\Users\Shunji\Documents\����csv\Loudness141111_001\';
wFilename = [wPass,'Table_Loudness_Parameters_',...
    num2str(deltaT),'deltaT',num2str(s_start),'-',num2str(s_end),'.csv'];
writetable(T,wFilename);
end