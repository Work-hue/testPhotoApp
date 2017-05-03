function [joint_error_table_array, ml_error, map_error, avg_error] = calc_error_two_features(patient, selected_features_array)
% selected_features_array is a 9*2 array

Joint_HT_table = cell(1,9);


for i = 1:9
    f1 = selected_features_array(i,1);
    f2 = selected_features_array(i,2);
    Joint_HT_table{1,i} = joint_ht(patient(i),f1,f2);
end

% TASK 3.2A

joint_ml_vecs = cell(1,9);
joint_map_vecs = cell(1,9);

for i = 1:9
    
    f1 = selected_features_array(i,1);
    f2 = selected_features_array(i,2);
    jht = Joint_HT_table{1,i};
    test_data_size = size(patient(i).test_data,2);
    
    joint_ml_vecs{1,i} = zeros(1,test_data_size);
    joint_map_vecs{1,i} = zeros(1,test_data_size);
    
    for j = 1:test_data_size
        
        % find rows in Joint_HT_table corresponding to feature idx f1
        idx1_arr = find(jht(:,1)==patient(i).test_data(f1,j));
        
        if size(idx1_arr,1)==0
            joint_ml_vecs{1,i}(1,j) = 1;
            joint_map_vecs{1,i}(1,j) = 1;
        else
            % take the subset of Joint_HT_table corresponding to feature idx f1
            jht_f1 = jht(idx1_arr,:);
            
            % find rows in the subset of Joint_HT_table corresponding to
            % feature idx f2
            idx2_arr = find(jht_f1(:,2)==patient(i).test_data(f2,j));
            if size(idx2_arr,1) == 0
                joint_ml_vecs{1,i}(1,j) = 1;
                joint_map_vecs{1,i}(1,j) = 1;
            else
                
                % idx2_arr should be one number
                %if size(idx2_arr) ~= 1
                %    'error: size(idx2_arr) ~= 1'
                %end
                
                % fill in the ml and map decision vectors
                joint_ml_vecs{1,i}(1,j) = jht_f1(idx2_arr(1,1),5);
                joint_map_vecs{1,i}(1,j) = jht_f1(idx2_arr(1,1),6);
            end
        end
    end
end

% TASK 3.2B

joint_error_table_array = cell(1,9);

for i = 1:9
    mat = zeros(2, 3);
    
    % ML rule
    [probFalse, probMiss, probError] = CompareVoter(joint_ml_vecs{1,i}, patient(i).test_labels);
    mat(1,1) = probFalse;
    mat(1,2) = probMiss;
    mat(1,3) = probError;
    
    % MAP rule
    [probFalse, probMiss, probError] = CompareVoter(joint_map_vecs{1,i}, patient(i).test_labels);
    mat(2,1) = probFalse;
    mat(2,2) = probMiss;
    mat(2,3) = probError;
    
    joint_error_table_array{1,i} = mat;
end

% calculate average error

ml_error = 0;
map_error = 0;

for i = 1:9
    ml_error = ml_error + joint_error_table_array{1,i}(1,3);
    map_error = map_error + joint_error_table_array{1,i}(2,3);
end

ml_error = ml_error / 9.0;
map_error = map_error / 9.0;

avg_error = (ml_error+map_error)/2.0;

end