function [out] = coalesce(in)
    out = [];
    for i = 1:10:(size(in,2)-9)
        flag = 0;
        for j = i:1:i+9
            if in(j)==1
                flag = 1;
            end
        end
        if flag == 1
            out = [out 1];
        else
            out = [out 0];
        end
    end