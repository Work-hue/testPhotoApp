function pe = p_error_map_whole(pat, feat_data)

    pat_mat = likelihood_matrix(feat_data, pat.train_labels);
    ht_table = zeros(size(pat_mat,1),5);
    map_vec = zeros(1,size(feat_data,2));
    
    
    
    num_data = size(feat_data,2);
    
    for i = 1:num_data
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
    
    for i = 1:size(pat_mat,2)
        if 
    end
    

%     % create ML and MAP vecs
%     ml_vecs = cell(1,7);
%     map_vecs = cell(1,7);
%     ml_dr_vec = zeros(1,size(pat.mats{1,j},2));
%     map_dr_vec = zeros(1,size(pat.mats{1,j},2));
%         for k = 1:size(patient(i).mats{1,j},2)
%             if (patient(i).mats{1,j}(2,k) >= patient(i).mats{1,j}(3,k))
%                 ml_dr_vec(1,k) = 1;
%             end
%             if (patient(i).mats{1,j}(2,k)*patient(i).h1 >= patient(i).mats{1,j}(3,k)*patient(i).h0)
%                map_dr_vec(1,k) = 1;
%             end 
%         end
%         patient(i).ml_vecs{1,j} = ml_dr_vec;
%         patient(i).map_vecs{1,j} = map_dr_vec;
%     end
%     end
% 
%     % create HT table
%     
%     pat_mat = likelihood_matrix(feat_data, pat.train_labels);
%     num_rows = size(pat_mat,2);
%     num_cols = 5;
%     mat = zeros(num_rows, num_cols);
%     % first column
%     mat(:,1) = (pat_mat(1,:))';
%     % second column
%     mat(:,2) = (pat_mat(2,:))';
%     % third column
%     mat(:,3) = (pat_mat(3,:))';
%     % fourth column
%     pat_ml_vec = pat.ml_vecs{1,feat_idx};
%     mat(:,4) = pat_ml_vec';
%     % fifth column
%     pat_map_vec = pat.map_vecs{1,feat_idx};
%     mat(:,5) = pat_map_vec';
%     
%     
%     error_table = create_error_table(pat, feat_idx, HT_tables{1,feat_idx});
%     MAP_errs = error_table(2,3);
%     pe = MAP_errs;
    
    
end