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
end

%% TASK 1.1A

for i = 1:9
    patient(i).h1 = sum(patient(i).train_data)/length(patient(i).train_data);
    patient(i).h0 = 1 - patient(i).h1;
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

%% TASK 1.1C

for i = 1:9
    figure(i);
    for j = 1:7
        subplot(7, 1, j);
        plot(patient(i).mats{1,j}(1,:), patient(i).mats{1,j}(3,:));  
        hold on;  
        plot(patient(i).mats{1,j}(1,:), patient(i).mats{1,j}(2,:)); 
        legend('H0 pmf', 'H1 pmf');
    end
end

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

%% TASK 1.1E

HT_table_array = cell(9,7);

for i = 1:9
    for j = 1:7
        HT_table_array{i,j} = create_ht_table(patient(i), j);
    end
end

