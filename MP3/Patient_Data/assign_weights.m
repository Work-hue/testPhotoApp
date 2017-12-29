function [weights] = assign_weights(pat, HT_tables)

    % HT_tables is a 1*7 cell array for that patient
    
    MAP_errs = zeros(1,7);
    for feat_idx = 1:7
        error_table = create_error_table(pat, feat_idx, HT_tables{1,feat_idx});
        MAP_errs(1,feat_idx) = error_table(2,3);
    end
    
    weights = zeros(1,7);
    for feat_idx = 1:7
        weights(1,feat_idx) = 1-MAP_errs(1,feat_idx);
    end
    
end