function [mat] = create_ht_table(pat, feat_idx)

    pat_mat = pat.mats{1,feat_idx};

    num_rows = size(pat_mat,2);
    num_cols = 5;
    mat = zeros(num_rows, num_cols);
    
    % first column
    mat(:,1) = (pat_mat(1,:))';
    
    % second column
    mat(:,2) = (pat_mat(2,:))';
    
    % third column
    mat(:,3) = (pat_mat(3,:))';
    
    % fourth column
    pat_ml_vec = pat.ml_vecs{1,feat_idx};
    mat(:,4) = pat_ml_vec';
    
    % fifth column
    pat_map_vec = pat.map_vecs{1,feat_idx};
    mat(:,5) = pat_map_vec';
    
end