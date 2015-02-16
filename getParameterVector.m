function [vec_time,vec_param] = getParameterVector...
    (filename,deltaT,shiftT,fft_size,len_sec,paramtype)
% [vec_time,vec_param] = getParameterVector...
%	(filename,deltaT,shiftT,fft_size,len_sec)
% 特徴ベクトル取得関数
%
% Input:
%	filename	: 音声ファイル名(.wav)
%	deltaT		: フレーム長(sec)
%	shiftT		: フレームシフト(sec)
%	fft_size	: FFT次数(2^n)
%	len_sec		: ファイル読み込みの際に分割する時間長(default=60)
%	paramtype 	: 特徴ベクトルの種類(default=1)
%
% Output:
%	vec_time	: 時間ベクトル
%	vec_param 	: 特徴ベクトル

if nargin<5
    len_sec = 60;
end
if nargin<6
    paramtype = 1;
end

% ループ上限を設定
a_info = audioinfo(filename);
dur = a_info.Duration;
i_stop = floor(dur/60);

vec_time = [];  % 時間ベクトル
vec_param = []; % 特徴ベクトル
% パラメータ取得全体での計算時間の計測開始
t_total = cputime;
for i=0:i_stop
    % 1分ごとのパラメータ取得の計算時間の計測開始
    t_part = cputime;
    display(['calculating ',num2str(i),' to ',num2str(i+1)]);

    % 60秒ごとにパラメータ取得関数に入るが，末尾でオーバーしないようにする
    if floor(dur-i*len_sec)<=len_sec
        interval = floor(dur)-i*len_sec;
        s_start = i*len_sec;
        s_end = s_start+interval;
    else
        s_start = i*len_sec;
        s_end = (i+1)*len_sec+shiftT;
    end
    
    % パラメータ取得し，一時変数に格納
    [t_time,t_vec] = getAcousticParameter...
        (filename,s_start,s_end,deltaT,shiftT,fft_size,paramtype);
    
    % 一時変数を結合
    vec_time = cat(1,vec_time,t_time);
    vec_param = cat(1,vec_param,t_vec);
    
    % 1分ごとのパラメータ取得の計算時間の計測終了
    t_part = cputime - t_part;
    display(['計算時間は ',num2str(t_part),' 秒です']);
end
% パラメータ取得全体での計算時間の計測終了
t_total = cputime - t_total;
display(['トータルの計算時間は ',num2str(t_total),' 秒です']);

end
