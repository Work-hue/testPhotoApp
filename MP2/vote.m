function [out] = vote(a, b, c)
    out = [];
    for i = 1:size(a,2)
        if a(i)+b(i)+c(i) >= 2
            out = [out 1];
        else
            out = [out 0];
        end
    end
end