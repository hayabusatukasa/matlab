function str_random = randomPickup(str_scene,num_pickup,sample_pickup)
% num_pickup = 100;
% sec_pickup = 10;    % in sec
% sample_pickup = sec_pickup/shiftT;    % in sample

% ��ʂ��Ƃɑf�ނ������_���Ƀs�b�N�A�b�v���C���ꂼ��̓_�����o��
rng('shuffle');
for i=1:length(str_scene)
    s_start = str_scene(i).time(1);
    s_end = str_scene(i).time(end);
    range_sample = length(str_scene(i).time)-sample_pickup;
    if (s_end-s_start) > sample_pickup 
        % �����_���ɑf�ނƂȂ镔���̊J�n�ʒu���w�萔�Ƃ�
        R = randi([1,range_sample],1,num_pickup);
        
        for j=1:num_pickup
            sum_score(j) = sum(str_scene(i).score(R(j):R(j)+sample_pickup));
            sum_start(j) = str_scene(i).time(R(j));
            sum_end(j)   = str_scene(i).time(R(j)+sample_pickup);
        end  
    else
        sum_score = [];
        sum_start = [];
        sum_end = [];
    end
    % �ꎞ�e�[�u���̍쐬�Ɠ_���ɂ��\�[�g
    T_tmp = table(sum_score',sum_start',sum_end','VariableNames',...
        {'score','s_start','s_end'});
    T_tmp = sortrows(T_tmp,'score','descend');
    % �\���̂Ɉꎞ�e�[�u�����i�[
    str_random(i).table = T_tmp;
end
end