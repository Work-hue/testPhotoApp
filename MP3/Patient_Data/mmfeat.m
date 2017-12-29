function [mat] = mmfeat(feat)

    max_h1 = max(feat(1,:));
    min_h1 = min(feat(1,:));
    
    max_h0 = max(feat(2,:));
    min_h0 = min(feat(2,:));
    
    mat = [min_h1, max_h1; min_h0, max_h0];
end