function str_random = randomPickup2(str_scene,num_pickup,sample_pickup)
% str_random = randomPickup2(str_scene,num_pickup,sample_pickup)
% ��ʂ��Ƃ̕����I�ӏ��̎擾
%
% Input:
%	str_scene	: ��ʂ��Ƃ̃X�R�A
%	num_pickup	: �����_���ȉӏ������o����
%	sample_pickup: ���o���ӏ��̃T���v����
%
% Output:
%	str_random	: �����_���Ɏ��o�����ӏ�

% ��ʂ��Ƃɑf�ނ������_���Ƀs�b�N�A�b�v���C���ꂼ��̓_�����o��
rng('shuffle');
for i=1:length(str_scene)
    s_start = str_scene(i).time(1);
    s_end = str_scene(i).time(end);
    % range_sample = length(str_scene(i).time)-sample_pickup;
    
    l = length(str_scene(i).score);
    if l >= sample_pickup
        n = num_pickup;
        range_sample = l-sample_pickup;
        
        % �����_���ɑf�ނƂȂ镔���̊J�n�ʒu���w�萔�Ƃ�
        R = randi([1,range_sample],1,n);
        
        for j=1:n
            sum_score(j) = sum(str_scene(i).score(R(j):R(j)+sample_pickup));
            sum_start(j) = str_scene(i).time(R(j));
            sum_end(j)   = str_scene(i).time(R(j)+sample_pickup);
        end
    else
        sum_score = sum(str_scene(i).score);
        sum_start = str_scene(i).time(1);
        sum_end   = str_scene(i).time(end);
    end
        
    % �ꎞ�e�[�u���̍쐬�Ɠ_���ɂ��\�[�g
    T_tmp = table(sum_score',sum_start',sum_end','VariableNames',...
        {'score','s_start','s_end'});
    T_tmp = sortrows(T_tmp,'score','descend');
    % �\���̂Ɉꎞ�e�[�u�����i�[
    str_random(i).table = T_tmp;
end
end
