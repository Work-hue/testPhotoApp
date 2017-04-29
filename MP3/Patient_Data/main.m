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

for i = 1:9
    votes = zeros(1,7);
    [feat_idx1, feat_idx2] = select_two_feats_ML_MAP(patient(i), HT_table_array(i,:));
    votes(1,feat_idx1) = votes(1,feat_idx1)+1;
    votes(1,feat_idx2) = votes(1,feat_idx2)+1;
    [feat_idx1, feat_idx2] = select_two_feats_cor_golden(patient(i));
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















