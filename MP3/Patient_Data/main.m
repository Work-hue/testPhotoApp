%% Start

clc
close all;
clear all;

% open the result file
% !! replace # with your own groupID
fid = fopen('ECE313_Final_group20_(winning_group)', 'w');

%% TASK 0

% LOAD PATIENT DATA

patient(1) = load('1_a41178.mat');
patient(2) = load('2_a42126.mat');
patient(3) = load('3_a40076.mat');
patient(4) = load('4_a40050.mat');
patient(5) = load('5_a41287.mat');
patient(6) = load('6_a41846.mat');
patient(7) = load('7_a41846.mat');
patient(8) = load('8_a42008.mat');
patient(9) = load('9_a41846.mat');

for i = 1:9
    patient(i).all_data_flr = floor(patient(i).all_data);
    patient(i).len = length(patient(i).all_labels);
    patient(i).train_data = patient(i).all_data_flr(:, 1:floor(((2/3)*patient(i).len)));
    patient(i).train_labels = patient(i).all_labels(:, 1:floor(((2/3)*patient(i).len)));
    patient(i).test_data = patient(i).all_data_flr(:, (floor(((2/3)*patient(i).len))+1):patient(i).len);
    patient(i).test_labels = patient(i).all_labels(:, (floor(((2/3)*patient(i).len))+1):patient(i).len);
    patient(i).pat_idx = i;
end

fprintf(fid, 'TASK 0\n\n');
fprintf(fid, 'In this task, we created an array of patient structures to keep track of all patient data.\n');
fprintf(fid, 'Each module loaded consisted of "all_data" and "all_labels" vectors. These vectors were\n');
fprintf(fid, 'stored in the patient structure. Next, the test and training data/label sets were created for\n');
fprintf(fid, 'each patient and appended.\n\n');

%% TASK 1.1A

for i = 1:9
    patient(i).h1 = sum(patient(i).train_labels)/length(patient(i).train_labels);
    patient(i).h0 = 1 - patient(i).h1;
end

fprintf(fid, 'TASK 1.1A\n\n');
fprintf(fid, 'The following are the prior probabilities of H1 and H0 respectively for each patient.\n\n');

for i = 1:9
    fprintf(fid, 'P(H1)=%d \t\t\t P(H0)=%d\n', patient(i).h1, patient(i).h0);
end

%% TASK 1.1B

for i = 1:9
    patient(i).mats = cell(1,7);
    %patient(i).maxminfeat = cell(1,7);
    for j = 1:7
        patient(i).mats{1,j} = likelihood_matrix(patient(i).train_data(j,:), patient(i).train_labels);
        %patient(i).mmfeat{1,j} = mmfeat(patient(i).mats{1,j});
    end
end

fprintf(fid, '\nTASK 1.1B\n\n');
fprintf(fid, 'For this task, we constructed the likelihood matrices for each of the seven features\n');
fprintf(fid, 'for each patient. This information can be seen in the patients structure. For each patient,\n');
fprintf(fid, 'there exists a 1x7 cell called "mats".\n\n');

%% TASK 1.1C

for i = 1:9
    figure(i);
    for j = 1:7
        subplot(7, 1, j);
        plot(patient(i).mats{1,j}(1,:), patient(i).mats{1,j}(3,:));
        hold on;
        plot(patient(i).mats{1,j}(1,:), patient(i).mats{1,j}(2,:));
        xlabel(['Feature']);
        ylabel('Probability');
        title('Probabilities of H0 & H1 vs. Feature');
        legend('H0 pmf', 'H1 pmf');
    end
end


fprintf(fid, 'TASK 1.1C\n\n');
fprintf(fid, 'When the code runs, 9 figures will be presented. These figures summarize our results as required.\n\n');

%% TASK 1.1D

for i = 1:9
    patient(i).ml_vecs = cell(1,7);
    patient(i).map_vecs = cell(1,7);
    for j = 1:7
        ml_dr_vec = zeros(1,size(patient(i).mats{1,j},2));
        map_dr_vec = zeros(1,size(patient(i).mats{1,j},2));
        for k = 1:size(patient(i).mats{1,j},2)
            if (patient(i).mats{1,j}(2,k) >= patient(i).mats{1,j}(3,k))
                ml_dr_vec(1,k) = 1;
            end
            if (patient(i).mats{1,j}(2,k)*patient(i).h1 >= patient(i).mats{1,j}(3,k)*patient(i).h0)
                map_dr_vec(1,k) = 1;
            end
        end
        patient(i).ml_vecs{1,j} = ml_dr_vec;
        patient(i).map_vecs{1,j} = map_dr_vec;
    end
end

fprintf(fid, 'TASK 1.1D\n\n');
fprintf(fid, 'For this task, we constructed the ML and MAP vectors for each patient. These vectors\n');
fprintf(fid, 'were appended to each patient structure in the patient array.\n\n');

%% TASK 1.1E

HT_table_array = cell(9,7);

for i = 1:9
    for j = 1:7
        HT_table_array{i,j} = create_ht_table(patient(i), j);
    end
end

fprintf(fid, 'TASK 1.1E\n\n');
fprintf(fid, 'For this task, we constructed the 9x7 HT_table_array. Each index into the array is an Fx5 array,\n');
fprintf(fid, 'where F is total number of distinct values a particular feature can take.\n\n');

%% TASK 1.2

Error_table_array = cell(9,7);

for i = 1:9
    for j = 1:7
        % fprintf('%d %d\n', i, j);
        % Problem encountered: Test data does not appear in training data
        % Wait for answer in Piazza
        % -> Already Solved
        Error_table_array{i,j} = create_error_table(patient(i), j, HT_table_array{i,j});
    end
end

fprintf(fid, 'TASK 1.2\n\n');
fprintf(fid, 'For this task, we constructed the 9x7 Error_table_array. Each index into the array is an 2x3 array.\n');
fprintf(fid, 'This smaller array contains the following information: P(False Alarm), P(Missed Detection),\n');
fprintf(fid, 'and P(Error). These values are presented in reference to both ML and MAP rules.\n\n');

%% TASK 2.1

fprintf(fid, 'TASK 2.1\n\n');

correlation_matrix = zeros(9,9);

for i = 1:9
    for k = 1:9
        len1 = size(patient(i).train_data,2);
        len2 = size(patient(k).train_data,2);
        minlen = min(len1,len2);
        data1 = patient(i).train_data(1,1:minlen);
        data2 = patient(k).train_data(1,1:minlen);
        cor = corrcoef(data1, data2);
        
        correlation_matrix(i,k) = cor(1,2);
        
        if((cor==1) & (i ~= k))
            %patients i and k have share same data
            fprintf(fid, 'Patients %d and %d have the same data.\n\n', i, k);
        end
        
    end
end

fprintf(fid, 'The correlation matrix is stored in the correlation_matrix variable. As one can see in the data structure, apart\n');
fprintf(fid, 'from the datasets of the same patients correlating with themselves, we can also see that there are datasets of different\n');
fprintf(fid, 'patients that have exactly the same data. These patients are patients 6 and 9. This redundancy is problematic and\n');
fprintf(fid, 'to improve our data overall we can choose to eliminate either patients data.\n\n');

%% TASK 2.2

% debug
%[feat_idx1, feat_idx2] = select_two_feats_ML_MAP(patient(1), HT_table_array(1,:))
%[feat_idx1, feat_idx2] = select_two_feats_cor_golden(patient(1));

% metric 1 - lowest ML/MAP & metric 2 - golden correlation

% for each patient, use a vote to select the best two features
% break ties arbitrarily

best_feat_indices = zeros(9,2);
best_feat_indices_metric1 = zeros(9,2);
best_feat_indices_metric2 = zeros(9,2);

for i = 1:9
    votes = zeros(1,7);
    [feat_idx1, feat_idx2] = select_two_feats_ML_MAP(patient(i), HT_table_array(i,:));
    best_feat_indices_metric1(i,1) = feat_idx1;
    best_feat_indices_metric1(i,2) = feat_idx2;
    votes(1,feat_idx1) = votes(1,feat_idx1)+1;
    votes(1,feat_idx2) = votes(1,feat_idx2)+1;
    [feat_idx1, feat_idx2] = select_two_feats_cor_golden(patient(i));
    best_feat_indices_metric2(i,1) = feat_idx1;
    best_feat_indices_metric2(i,2) = feat_idx2;
    votes(1,feat_idx1) = votes(1,feat_idx1)+1;
    votes(1,feat_idx2) = votes(1,feat_idx2)+1;
    
    [val, feat_idx1] = max(votes);
    votes2 = votes(:);
    votes2(feat_idx1) = -inf;
    [val2, feat_idx2] = max(votes2);
    
    best_feat_indices(i,1) = feat_idx1;
    best_feat_indices(i,2) = feat_idx2;
end

% metric 3 - correlation (not used)

best_feat_corr = zeros(9,2);

for i = 1:9
    patient(i).feat_corr = feature_corrs(patient(i));
    min_corr = min(min(patient(i).feat_corr));
    [min_row, min_col] = find(patient(i).feat_corr==min_corr);
    min_row = min_row(1);
    min_col = min_col(1);
    best_feat_corr(i,1) = min_row;
    best_feat_corr(i,2) = min_col;
end

% This section calculates errors

% errors = zeros(1,9);
% for i = 1:9
%     errors(1,i) = p_error_map(patient(i), best_feat_indices(i,1), HT_table_array(i,:));
% end
% disp(errors)

% % sanity check that our feature selection actually works
% errors2 = zeros(1,9);
% for i = 1:9
%     errors2(1,i) = p_error_map(patient(i), 2, HT_table_array(i,:));
% end
% disp(errors2)

% Technique 4: weights (calculated but not used)

weights_for_all_pat = zeros(9,7);
for i = 1:9
    weights_for_all_pat(i,:) = assign_weights(patient(i), HT_table_array(i,:));
    patient(i).weights = weights_for_all_pat(i,:);
end


fprintf(fid, 'TASK 2.2\n\n');
fprintf(fid, 'For this task, we implemented two ways to select the top two features. The first way was to find\n');
fprintf(fid, 'the top two features that had the lowest min(ML error, MAP error) value. This method is expected to work because\n');
fprintf(fid, 'intuitively, a feature is good if it has the lowest error using the MAP or ML decision rules. \n');
fprintf(fid, 'The second way was to find the top two features that had the closest correlation to the golden alarms.\n');
fprintf(fid, 'It is a good method because intuitively, a feature has a strong influence on the actual result if it is \n');
fprintf(fid, 'strongly correlated with the golden labels.\n');
fprintf(fid, '\nWe found that the top two features for the three patients we chose (1,2,3) are:\n\n');

fprintf(fid, 'Patient 1: 1 \t 3\n');
fprintf(fid, 'Patient 2: 1 \t 3\n');
fprintf(fid, 'Patient 3: 2 \t 4\n\n');

fprintf(fid, 'We attempted to conclude a better pair of features by experimenting with metrics 3 and 4. After doing a majority vote\n');
fprintf(fid, 'using metrics 1 and 2, we wanted to verify the pair of features we obtained using metric 3s feature correlation.\n');
fprintf(fid, 'When taking the minimum correlation between pairs of features, we noticed that the pairs we got differed from the pairs obtained\n');
fprintf(fid, 'we obtained earlier. From this point, we concluded that there was no evidence that justified which pair to choose from the pool.\n');
fprintf(fid, '\nWe also attempted to use metric 4 to create a new feature consisting of a weighted sum of the original features.\n');
fprintf(fid, 'We calculated the weights of each feature based on its accuracy in MAP decision rule. The weights are stored in patient(i).weights\n');
fprintf(fid, 'variable. However, we did not make use of the weights to find our top two choices of features, because we decided that there is no\n');
fprintf(fid, 'convenient way to test on the new feature created.\n\n');
fprintf(fid, ' \n');

%% TASK 3.1ABC

for i = 1:9
    f1 = best_feat_indices(i,1);
    f2 = best_feat_indices(i,2);
    patient(i).Joint_HT_table = joint_ht(patient(i),f1,f2);
end

%% TASK 3.1D

for i = 1:3
    f1 = best_feat_indices(i,1);
    f2 = best_feat_indices(i,2);
    feat1 = patient(i).mats{1,f1};
    feat2 = patient(i).mats{1,f2};
    size_f1 = size(feat1,2);
    size_f2 = size(feat2,2);
    
    pmf_h1 = zeros(size_f1,size_f2);
    pmf_h0 = zeros(size_f1,size_f2);
    
    for j = 1:size_f1
        for k = 1:size_f2
            row_num = (j-1)*size_f2+k;
            pmf_h1(j,k) = patient(i).Joint_HT_table(row_num,3);
            pmf_h0(j,k) = patient(i).Joint_HT_table(row_num,4);
        end
    end
    
    figure
    mesh(feat2(1,:),feat1(1,:),pmf_h1);
    figure
    mesh(feat2(1,:)',feat1(1,:)',pmf_h0);
end

%% TASK 3.2A

for i = 1:9
    
    f1 = best_feat_indices(i,1);
    f2 = best_feat_indices(i,2);
    jht = patient(i).Joint_HT_table;
    test_data_size = size(patient(i).test_data,2);
    
    patient(i).joint_ml_vec = zeros(1,test_data_size);
    patient(i).joint_map_vec = zeros(1,test_data_size);
    
    for j = 1:test_data_size
        
        % find rows in Joint_HT_table corresponding to feature idx f1
        idx1_arr = find(jht(:,1)==patient(i).test_data(f1,j));
        
        if size(idx1_arr,1)==0
            patient(i).joint_ml_vec(1,j) = 1;
            patient(i).joint_map_vec(1,j) = 1;
        else
            % take the subset of Joint_HT_table corresponding to feature idx f1
            jht_f1 = jht(idx1_arr,:);
            
            % find rows in the subset of Joint_HT_table corresponding to
            % feature idx f2
            idx2_arr = find(jht_f1(:,2)==patient(i).test_data(f2,j));
            if size(idx2_arr,1) == 0
                patient(i).joint_ml_vec(1,j) = 1;
                patient(i).joint_map_vec(1,j) = 1;
            else
                
                % idx2_arr should be one number
                %if size(idx2_arr) ~= 1
                %    'error: size(idx2_arr) ~= 1'
                %end
                
                % fill in the ml and map decision vectors
                patient(i).joint_ml_vec(1,j) = jht_f1(idx2_arr(1,1),5);
                patient(i).joint_map_vec(1,j) = jht_f1(idx2_arr(1,1),6);
            end
        end
    end
end

%% TASK 3.2B

joint_error_table_array = cell(1,9);

for i = 1:9
    mat = zeros(2, 3);
    
    % ML rule
    [probFalse, probMiss, probError] = CompareVoter(patient(i).joint_ml_vec, patient(i).test_labels);
    mat(1,1) = probFalse;
    mat(1,2) = probMiss;
    mat(1,3) = probError;
    
    % MAP rule
    [probFalse, probMiss, probError] = CompareVoter(patient(i).joint_map_vec, patient(i).test_labels);
    mat(2,1) = probFalse;
    mat(2,2) = probMiss;
    mat(2,3) = probError;
    
    joint_error_table_array{1,i} = mat;
end

%% TASK 3.2C
for i = 1:9
    figure(i);
    subplot(3, 1, 1);
    bar(patient(i).joint_ml_vec);
    xlabel(['ML']);
    ylabel('Alarm');
    title_str = sprintf('Alarms of Patient %d',i);
    title(title_str);
    subplot(3, 1, 2);
    bar(patient(i).joint_map_vec);
    xlabel(['MAP']);
    ylabel('Alarm');
    subplot(3, 1, 3);
    bar(patient(i).test_labels);
    xlabel(['Golden']);
    ylabel('Alarm');
end

%% TASK 3.3B
joint_error_table_array_try_array = cell(1,10);
ml_error_array = cell(1,10);
map_error_array = cell(1,10);
avg_error_array = cell(1,10);

% 1st: metric 1 and 2
[joint_error_table_array_try_array{1,1}, ml_error_array{1,1}, map_error_array{1,1}, avg_error_array{1,1}] = calc_error_two_features(patient, best_feat_indices);

% 2nd: metric 3
[joint_error_table_array_try_array{1,2}, ml_error_array{1,2}, map_error_array{1,2}, avg_error_array{1,2}] = calc_error_two_features(patient, best_feat_corr);

% 3st: only use feature 1
default_feat = ones(9,2);
[joint_error_table_array_try_array{1,3}, ml_error_array{1,3}, map_error_array{1,3}, avg_error_array{1,3}] = calc_error_two_features(patient, default_feat);

% 4th: metric 1 only
[joint_error_table_array_try_array{1,4}, ml_error_array{1,4}, map_error_array{1,4}, avg_error_array{1,4}] = calc_error_two_features(patient, best_feat_indices_metric1);

% 5th: metric 2 only
[joint_error_table_array_try_array{1,5}, ml_error_array{1,5}, map_error_array{1,5}, avg_error_array{1,5}] = calc_error_two_features(patient, best_feat_indices_metric2);

% 6th: for each patient, the first feature gives the lowest ml error,
% the second feature gives the lowest map error
best_feat_indices_ml_map = zeros(9,2);
for i = 1:9
    min_ml_idx = 0;
    min_ml_err = 1;
    min_map_idx = 0;
    min_map_err = 1;
    for j = 1:7
        if (Error_table_array{i,j}(1,3)<min_ml_err)
            min_ml_err = Error_table_array{i,j}(1,3);
            min_ml_idx = j;
        end
        if (Error_table_array{i,j}(2,3)<min_map_err)
            min_map_err = Error_table_array{i,j}(2,3);
            min_map_idx = j;
        end
    end
    best_feat_indices_ml_map(i,1) = min_ml_idx;
    best_feat_indices_ml_map(i,2) = min_map_idx;
end
[joint_error_table_array_try_array{1,6}, ml_error_array{1,6}, map_error_array{1,6}, avg_error_array{1,6}] = calc_error_two_features(patient, best_feat_indices_ml_map);

% 7th: for each patient, try all pairs of features, select the pair that
% gives the lowest average error
best_feat_indices_avg_error = zeros(9,2);
for i = 1:9
    min_f1 = 0;
    min_f2 = 0;
    min_avg_err = 1;
    for j = 1:7
        for k = j+1:7
            [joint_error_table_array, ml_error, map_error, avg_error] = calc_error_two_features_one_patient(patient(i), j,k);
            if (avg_error<min_avg_err)
                min_avg_err = avg_error;
                min_f1 = j;
                min_f2 = k;
            end
        end
    end
    best_feat_indices_avg_error(i,1) = min_f1;
    best_feat_indices_avg_error(i,2) = min_f2;
end
[joint_error_table_array_try_array{1,7}, ml_error_array{1,7}, map_error_array{1,7}, avg_error_array{1,7}] = calc_error_two_features(patient, best_feat_indices_avg_error);



% goal: best_feat_indices_final;

%% TASK 3.4
for i = 1:9
    test_data_size = size(patient(i).test_data,2);
    scores_test = zeros(1,test_data_size);
    f1 = best_feat_indices(i,1); % to be revised
    f2 = best_feat_indices(i,2); % to be revised 
    jht = patient(i).Joint_HT_table;
    
    for j = 1:test_data_size
        % find rows in Joint_HT_table corresponding to feature idx f1
        idx1_arr = find(jht(:,1)==patient(i).test_data(f1,j));
        
        if size(idx1_arr,1)==0
            scores_test(1,j) = 1;
        else
            % take the subset of Joint_HT_table corresponding to feature idx f1
            jht_f1 = jht(idx1_arr,:);
            
            % find rows in the subset of Joint_HT_table corresponding to
            % feature idx f2
            idx2_arr = find(jht_f1(:,2)==patient(i).test_data(f2,j));
            if size(idx2_arr,1) == 0
                scores_test(1,j) = 1;
            else
                
                % idx2_arr should be one number
                %if size(idx2_arr) ~= 1
                %    'error: size(idx2_arr) ~= 1'
                %end
                
                % fill in the ml and map decision vectors
                scores_test(1,j) = jht_f1(idx2_arr(1,1),3);
            end
        end
    end
    
    % plot performance curve
    [X,Y] = perfcurve(patient(i).test_labels,scores_test,1);
    figure(i);
    plot(X,Y);
    xlabel('False positive rate')
    ylabel('True positive rate')
    title('ROC Curve')
end

