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
    
    
    mat_row1 = probs1';
    mat_row0 = probs0';
    
    mat = [mat_row1; mat_row0];
end