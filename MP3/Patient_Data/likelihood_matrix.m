function [mat] = likelihood_matrix(feat, labels)

    idx1 = labels==1;
    idx0 = labels==0;
    
    feat1 = feat(idx1);
    feat0 = feat(idx0);
    
    tab1 = tabulate(feat1);
    tab0 = tabulate(feat0);
        
    values1 = tab1(:,1);
    probs1 = tab1(:,3)/100;
    
    values0 = tab0(:,1);
    probs0 = tab0(:,3)/100;
    
    min_feat_val = min(feat);
    max_feat_val = max(feat);
    num_col = max_feat_val - min_feat_val + 1;
    
    mat_row1 = zeros(1,num_col);
    mat_row0 = zeros(1,num_col);
    mat_row_val = zeros(1,num_col);
    
    for i = 1:num_col
        mat_row_val(1,i) = min_feat_val+i-1;
        if (sum(values1==min_feat_val+i-1)>0) % min_feat_val+i-1 is in values1
            val_idx = find(values1==min_feat_val+i-1);
            mat_row1(1,i) = probs1(val_idx,1);
        end
        if (sum(values0==min_feat_val+i-1)>0) % min_feat_val+i-1 is in values0
            val_idx = find(values0==min_feat_val+i-1);
            mat_row0(1,i) = probs0(val_idx,1);
        end
    end
    
    mat = [mat_row_val; mat_row1; mat_row0];
    
    %length(mat_row1)
    %length(mat_row1(1,:))
    %length(mat_row0)
    
    %printf("dim of mat: %d %d\n",length(mat),length(mat(1)))
    
end