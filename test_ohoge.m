clear N_specif;
clear ws;
% fname_withoutWAV = '141105_001';
filename = [fname_withoutWAV,'.WAV'];
a_info = audioinfo(filename);
i_stop = floor(a_info.Duration/60)-1;
t_total = cputime;
for i=0:i_stop
    t_part = cputime;
    display(['calculating ',num2str(i),' to ',num2str(i+1)]);
    [N_specif(:,:,i+1),ws(i+1)] = ohoge(fname_withoutWAV,i*60,(i+1)*60);
    t_part = cputime - t_part;
    display(['ŒvZŠÔ‚Í ',num2str(t_part),' •b‚Å‚·']);
end
t_total = cputime - t_total;
display(['ƒg[ƒ^ƒ‹‚ÌŒvZŠÔ‚Í ',num2str(t_total),' •b‚Å‚·']);
wfname_N_specif = ['N_specif_',fname_withoutWAV,'.mat'];
wfname_ws = ['ws_',fname_withoutWAV,'.mat'];
save(wfname_N_specif,'N_specif');
save(wfname_ws,'ws');