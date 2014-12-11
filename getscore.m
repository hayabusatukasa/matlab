function result = getscore(LNscore,SPscore,type)
if nargin<3
    type = 1;
end

switch type
    case 1
        result = 100*LNscore*SPscore;
    case 2
        result = 50*LNscore+50*SPscore;
    otherwise
        result = 100*LNscore*SPscore;
end
end