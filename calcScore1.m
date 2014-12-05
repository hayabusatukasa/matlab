function score = calcScore1(time,db,cent)

% ���ȏ��dB�����C���f�b�N�X�݂̂����o��
P0 = 2e-5;
thsld_amp = 0;                       % threshold in amplitude
thsld_db = 10*log10(thsld_amp^2/P0^2);  % in db
upperthsld = (db>=thsld_db);
db_upperthsld = db(upperthsld);
cent_upperthsld = cent(upperthsld);

% �X�R�A1�̌v�Z�ɗp����C�S�̂������Ƃ��̒����l�ƕW���΍�
me_db = mean(db_upperthsld);
sd_db = std(db_upperthsld);
me_cent = mean(cent_upperthsld);
sd_cent = std(cent_upperthsld);

len = length(time);
for i=1:len
    % �X�R�A1�̌v�Z
    score_db(i) = detcurve(db(i),me_db,sd_db);
    score_cent(i) = detcurve(cent(i),me_cent,sd_cent);
    score(i) = getscore(score_db(i),score_cent(i));
end
end