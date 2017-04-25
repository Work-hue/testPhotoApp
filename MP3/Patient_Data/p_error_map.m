function pe = p_error_map(pat, feat_idx, HT_tables)

    % HT_tables is a 1*7 cell array for that patient
    
    error_table = create_error_table(pat, feat_idx, HT_tables{1,feat_idx});
    MAP_errs = error_table(2,3);
    pe = MAP_errs;
    
    
end