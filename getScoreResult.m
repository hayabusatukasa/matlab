function result = getScoreResult(t_score,type)
% result = getScoreResult(t_score,type)
% �X�R�A�v�Z�֐��imax:100�Cmin:0�j
% Input:
%	t_score	: �p�����[�^���Ƃ̃X�R�A
%	type 	: �X�R�A�v�Z���@
%
% Output:
%	result	: �X�R�A�v�Z����

if nargin<2
    type = 1;
end

switch type
    case 1
        result = 100*prod(t_score);
    otherwise
        result = 100*prod(t_score);
end
end
