function pe = calc_weighted_error(pat, HT_table_array)

    
    num_data = size(pat.test_labels,2);
    predicted_labels_map = zeros(7,num_data);
    
    
    for feat_idx = 1:7
        data_vec = pat.test_data(feat_idx,:);
        ht_table = HT_table_array{pat.pat_idx, feat_idx};
        for i = 1:num_data
            row_indices_in_ht = find(ht_table==data_vec(i));
            if (size(row_indices_in_ht,1)==0)
                %fprintf('Test data do not appear in training data\n');
                % prediction favors H1
                predicted_labels_map(feat_idx,i) = 1;
            else
                % MAP rule
                predicted_labels_map(feat_idx,i) = ht_table(row_indices_in_ht(1,1),5);
            end

        end
    end
    
    predicted_labels_map_weighted = zeros(1,num_data);
    for j = 1:num_data
        weighted_sum = sum(pat.weights .* predicted_labels_map(:,i)') / sum(pat.weights);
        if (weighted_sum >= 0.5)
            predicted_labels_map_weighted(j) = 1;
        else
            predicted_labels_map_weighted(j) = 0;
        end
    end
    
    % MAP rule
    [probFalse, probMiss, probError] = CompareVoter(predicted_labels_map_weighted, pat.test_labels);
    
    pe = probError;
    
    
end