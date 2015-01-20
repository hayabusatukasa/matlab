label = {'141104_002','141105_001' ,'141111_001' ,'141121_001' ,'141121_002', ...
    '141226_001' ,'141226_002'};

bpm = 100;
for num=1:length(label)
    fname_withoutWAV = cell2mat(label(num));
    soundPickuper;
end

bpm = 120;
for num=1:length(label)
    fname_withoutWAV = cell2mat(label(num));
    soundPickuper;
end
