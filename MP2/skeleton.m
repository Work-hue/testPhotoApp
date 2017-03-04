%   FILL IN / MODIFY THE CODE WITH '' or comments with !!

clc
close all;
clear all;

% Load patient_data.mat 
load('patient_data.mat');
labels = {'Heart Rate','Pulse Rate','Respiration Rate'};

% open the result file
% !! replace # with your own groupID
fid = fopen('ECE313_Mini2_group20', 'w');

% T0
% !! Subset your data for each signal
HR = data(1,:);
PR = data(2,:);
X = data(3,:);

% Part a
% !! Plot each signal over time
figure;
m = size(data,2);
x = [1:1:m];
subplot(3,1,1);
plot(x,HR);
xlabel('Time(seconds)');
ylabel('Number of Contractions');
title(labels(1));
subplot(3,1,2);
plot(x,PR);
xlabel('Time(seconds)');
ylabel('Pulse')
title(labels(2));
subplot(3,1,3);
plot(x,X);
xlabel('Time(seconds)');
ylabel('Breaths')
title(labels(3));

% Note that Tasks 1.1 and 1.2 should be done only for the respiration rate signal 
% Tasks 2.1 and 2.2 should be performed using all three signals.
% T1.1
% Part a
% Generating three sample sets of different sizes

sampleset = [70,1000,30000];
for k = 1:3
    % Pick a random sample of size sampleset(k) from the data set  
    % (Without replacement)
    
    Sample = datasample(X, sampleset(k), 'Replace', false);
    
    % Plot the CDF of the whole data set as the reference (in red color)
    figure;  
    subplot(2,1,1);
    [p, xx] = ecdf(Sample);
    plot(xx,p);
    %hold on;% For the next plots to be on the same figure        
    h = get(gca,'children'); set(h,'LineWidth',2);set(h,'Color','r')
    
    % !! Call the funcion for calculating and ploting pdf and CDF of X     
    pdf_cdf(Sample);
    
    title(strcat(strcat(char(labels(3)),' - Sample Size = '),char(num2str(sampleset(k)))));
end

fprintf(fid, 'Task 1.1a \n\n');
fprintf(fid, 'The biggest difference between the pmf and the pdf is that the pmf depicts interval based probabilities while the pdf approximates\n');
fprintf(fid, 'the probabilities over a continuum of sample points. The pdf can be seen as an upper envelope of the pmf given a particular dataset. As\n');
fprintf(fid, 'the number of samples increases, the pdf takes on a more accurate upper envelope of the pmf. As the sample size increases,\n');
fprintf(fid, 'the pmf and the pdf of the sampleset more closely resemble the pmf and pdf of the entire dataset.\n\n');

%
% Part b
% !! Use the tabulate function in MATLAB over X and floor(X). 

X_tab = tabulate(X);
Y = floor(X);
Y_tab = tabulate(Y);

X_tab_min = min(X_tab(:,3)); 
X_tab_max = max(X_tab(:,3));
Y_tab_min = min(Y_tab(:,3));
Y_tab_max = max(Y_tab(:,3));

% !! Answer the question by filling in the following printf
fprintf(fid, 'Task 1.1b\n\n');
fprintf(fid, 'Min of tabulate(X) = %f%%\n', X_tab_min);
fprintf(fid, 'Max of tabulate(X) = %f%%\n', X_tab_max);
fprintf(fid, 'Min of tabulate(floor(X)) = %f%%\n', Y_tab_min);
fprintf(fid, 'Max of tabulate(floor(X)) = %f%%\n', Y_tab_max);


fprintf(fid, 'Question 1:\n');
fprintf(fid, 'Tabulate(X) gives an estimated pdf because the original dataset of all possible respiration rates is meant to be continuous. X  \n');
fprintf(fid, '\n\n');
fprintf(fid, 'Question 2:\n');
fprintf(fid, '\n');
fprintf(fid, '\n\n');
fprintf(fid, 'Question 3:\n');
fprintf(fid, 'Observed Property of PDF: %s\n\n', 'The integral of f(x) for all x is equal to 1.');

%%
% Part c
% !! Using CDF of X, find values a and b such that P(X <= a) <= 0.02 and P(X <= b) >= 0.98.

%a = 
%b = 
fprintf(fid, 'Task 1.1 - Part c\n');
fprintf(fid, 'Empirical a = %f\n', 'Empirical a');
fprintf(fid, 'Empirical b = %f\n\n', 'Empirical b');

%% Task 1.2;

% Part a
% !! Calculate mean of the signal

fprintf(fid, 'Task 1.2 - Part a\n');
fprintf(fid, 'Mean RESP = %f\n\n', 'Mean RESP');
% !! Calculate standard deviation of the signal

fprintf(fid, 'Standard Deviation RESP = %f\n', 'Standard Deviation of RESP');

% Part b
% !! Generate a normal random variable with the same mean & standard deviation 

% !! Plot pdf and CDF of the generated random variable using pdf_cdf function
figure;

title(strcat(char(labels(3)),' Normal Approximation'));


% Part c
figure;
title(strcat(char(labels(3)),' Normplot'));
% !! Use normplot function to estimate the difference between distributions



% Part d
% !! Show your work in the report, then plug in the numbers that you calculated here
fprintf(fid, 'Task 1.2 - Part d\n');
fprintf(fid, 'Theoretical a = %f\n', 'Theoretical a');
fprintf(fid, 'Theoretical b = %f\n\n', 'Theoretical b');

%% Task 2.1;
% Tasks 2.1 and 2.2 should be done twice, 
% once with the empirical threshold, and once with the theoretical threshold
% !! Change the code to do this.

% Part a
% !! Call the threshold function and generate alarms for each signal



% Parts b and c
% !! Write the code for coalescing alarms and majority voting here 





% Part d
% !! Fill in the bar functions with the name of vectors storing your alarms
figure;
subplot(5,1,1);
bar('HR Alarms');
title(strcat(char(labels(1)),' Alarms'));
subplot(5,1,2);
bar('PR Alarms');
title(strcat(char(labels(2)),' Alarms'));
subplot(5,1,3);
bar('RESP Alarms');
title(strcat(char(labels(3)),' Alarms'));
subplot(5,1,4);
bar('Majority Voter Alarms');
title('Majority Voter Alarms - Empirical Thresholds');
subplot(5,1,5);
title('Golden Alarms');
bar('Golden Alarms','r');

%% Task 2.2;
% Parts a and b
% !! Write the code to calculate the probabilities of:
%    false alarm, miss detection and error 





fprintf(fid, 'Task 2.2 - Parts a and b\n');
fprintf(fid, 'Using Empirical Thresholds:\n');
fprintf(fid, 'Probability of False Alarm    = %f\n', 'False Alarm');
fprintf(fid, 'Probability of Miss Detection = %f\n', 'Miss Detect');
fprintf(fid, 'Probability of Error          = %f\n\n', 'Error');

% Part c
% !! Repeat Tasks 2.1 and 2.2 with Theoretical thresholds



figure;
subplot(5,1,1);
bar('HR Alarms');
title(strcat(char(labels(1)),' Alarms'));
subplot(5,1,2);
bar('PR Alarms');
title(strcat(char(labels(2)),' Alarms'));
subplot(5,1,3);
bar('RESP Alarms');
title(strcat(char(labels(3)),' Alarms'));
subplot(5,1,4);
bar('Majority Voter Alarms');
title('Majority Voter Alarms - Theoretical Thresholds');
subplot(5,1,5);
title('Golden Alarms');
bar('Golden Alarms','r');


fprintf(fid, 'Task 2.2 - Part c\n');
fprintf(fid, 'Using Theoretical Thresholds:\n');
fprintf(fid, 'Probability of False Alarm    = %f\n', 'False Alarm');
fprintf(fid, 'Probability of Miss Detection = %f\n', 'Miss Detect');
fprintf(fid, 'Probability Error             = %f\n\n', 'Error');



%% Task 3

% Prob. of error from the testing process of each fold
nFold_p_error = [];         
% Prob. of false positives from the testing process of each fold
nFold_p_fp = [];        
% Prob. of miss detection from the testing process of each fold
nFold_p_md = [];        


% Part a.1: Divide the data into three subsets of equal length


% Part a.2: Divide the golden_alarms into three subsets of equal length



for i=1:3
    % Hint: z = [x y]; merges the two datasets x and y

  %  trainData = 
   % testData = 

    % Part b: Train the decision model using trainData


    % Part c: Test the decision model using testData

end

% Find the mean of the the performances from the 3-fold analysis
% Hint: mean(x) provides the mean of elements in array x


fprintf(fid, 'Task 3\n');
fprintf(fid, 'Mean Probability of False Alarm = %f\n', 'Mean False Alarm');
fprintf(fid, 'Mean Probability of Miss Detection = %f\n', 'Mean Miss Detection');
fprintf(fid, 'Mean Probability of Error = %f\n', 'Mean Error');


fclose(fid);