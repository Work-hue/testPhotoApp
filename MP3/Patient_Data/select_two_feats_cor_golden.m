function [feat_idx1, feat_idx2] = select_two_feats_cor_golden(pat)

    % calculate correlation scores
    for i = 1:7
        % score: 1 - identically correlated
        %        0 - not correlated
        %        -1 - completely inversely correlated
         cor_array = corrcoef(pat.train_data(i,:), pat.train_labels);
         % cor_array(1,2) usually indicates the above score
         cor_score(i) = cor_array(1,2); 
    end
    
    % find the two closest to 1 or -1
    cor_score_abs = abs(cor_score);
    [val, feat_idx1] = max(cor_score_abs);
    cor_score_abs2 = cor_score_abs(:);
    cor_score_abs2(feat_idx1) = -inf;
    [val2, feat_idx2] = max(cor_score_abs2);
end