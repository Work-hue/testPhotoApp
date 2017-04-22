function [mat] = create_error_table(pat, feat_idx, ht_table)

    pat_mat = pat.mats{1,feat_idx};

    mat = zeros(2, 3);
    
    num_data = size(pat.test_labels,2);
    predicted_labels_ml = zeros(1,num_data);
    predicted_labels_map = zeros(1,num_data);
    data_vec = pat.test_data(feat_idx,:);
    
    for i = 1:num_data
        row_indices_in_ht = find(ht_table==data_vec(i));
        if (size(row_indices_in_ht,1)==0)
            %fprintf('Test data do not appear in training data\n');
            % prediction favors H1
            predicted_labels_ml(1,i) = 1;
            predicted_labels_map(1,i) = 1;
        else
            % ML rule
            predicted_labels_ml(1,i) = ht_table(row_indices_in_ht(1,1),4);
            % MAP rule
            predicted_labels_map(1,i) = ht_table(row_indices_in_ht(1,1),5);
        end
        
    end
    
    % ML rule
    [probFalse, probMiss, probError] = CompareVoter(predicted_labels_ml, pat.test_labels);
    mat(1,1) = probFalse;
    mat(1,2) = probMiss;
    mat(1,3) = probError;
    
    % MAP rule
    [probFalse, probMiss, probError] = CompareVoter(predicted_labels_map, pat.test_labels);
    mat(2,1) = probFalse;
    mat(2,2) = probMiss;
    mat(2,3) = probError;
    
    
end