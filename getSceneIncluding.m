function [SI,SS] = getSceneIncluding(T_scene_tp,T_scene_det)

len1 = [T_scene_tp.scene_end - T_scene_tp.scene_start];
len2 = [T_scene_det.scene_end - T_scene_det.scene_start];
SI=[];
SS=[];

istop = height(T_scene_tp);
n = 1;
SI = zeros(istop,1);
hp1 = len1(1);
hp2 = len2(1);
i=1; j=1;
while i<=istop
    hp1rest = hp1 - hp2;
    hp2rest = hp2 - hp1;
    if hp1rest>0
        SI(i) = SI(i)+hp2/len2(j);
        j=j+1;
        hp1 = hp1rest;
        hp2 = len2(j);
    elseif hp2rest>0
        SI(i) = SI(i)+hp1/len2(j);
        i=i+1;
        if i>istop
            break;
        end
        hp1 = len1(i);
        hp2 = hp2rest;
    else
        SI(i) = SI(i)+hp1/len2(j);
        i=i+1;
        j=j+1;
        if i>istop
            break;
        end
        hp1 = len1(i);
        hp2 = len2(j);
    end
end

% for i=1:istop
%     if SI(i)>1
%         SI(i) = 1/SI(i);
%     end
% end


thr = 10;
jstop = height(T_scene_det);
for i=1:istop
    for j=1:jstop
        SS(i,j) = abs(T_scene_tp.scene_start(i)...
            - T_scene_det.scene_start(j));
    end
end
SS = 1./SS;

end