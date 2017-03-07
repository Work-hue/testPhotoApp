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
    xlabel('X');
    ylabel('Probability');
    title('CDF');
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
fprintf(fid, 'Max of tabulate(floor(X)) = %f%%\n\n', Y_tab_max);


fprintf(fid, 'Question 1:\n');
fprintf(fid, 'Tabulate(X) gives an estimated pdf because the original dataset of all possible respiration rates is meant to be continuous.\n');
fprintf(fid, 'Furthermore, tabulate(X) returns the probabilities representing the relative likelihood of all possible respiration rate values.\n');
fprintf(fid, 'Tabulate (Y) gives a pmf because after using the floor function on X, all the possible respiration rates are truncated. This causes\n');
fprintf(fid, 'the random variable to take on discrete values.\n\n');

fprintf(fid, 'Question 2:\n');
fprintf(fid, 'For the X dataset, the min and max probabilities are equal, because without the floor function, each respiration rate is distinct \n');
fprintf(fid, 'and therefore is as likely to appear as any other respiration rate. \n');
fprintf(fid, 'For the Y dataset, the min and max probabilities are not equal because with the floor function, all the values corresponding to the respiration \n');
fprintf(fid, 'rates are truncated. Hence, multiple respiration rates from the original data now share common Y values. Consequently, the frequency for each Y \n');
fprintf(fid, 'value can vary.\n\n');

fprintf(fid, 'Question 3:\n');
fprintf(fid, 'The probability that X will be contained in an interval of length ? around the point a is approximately ?f(a).\n');
fprintf(fid, 'If we let ? be small enough such that each interval of length ? only contains at most one sample, then each existing respiration rate value\n');
fprintf(fid, 'corresponds to exactly one sample, which accounts for the reason that for the X dataset, the min and max probabilities are equal.\n');
fprintf(fid, 'However, that is not true for PMF, since after taking Y = floor(X) in this case, necessarily some Y value could correspond to multiple samples.\n');
fprintf(fid, 'Consequently, the frequency for each Y value can vary, and therefore for the Y dataset, the min and max probabilities are not equal.\n\n');

%
% Part c
% !! Using CDF of X, find values a and b such that P(X <= a) <= 0.02 and P(X <= b) >= 0.98.
sorted_X = sort(X);
a = sorted_X(600);
b = sorted_X(29400);
fprintf(fid, 'Task 1.1c\n\n');
fprintf(fid, 'Empirical a = %f\n', a);
fprintf(fid, 'Empirical b = %f\n\n', b);

% Task 1.2;

% Part a
% !! Calculate mean of the signal
mean_X = mean(X);
fprintf(fid, 'Task 1.2a\n\n');
fprintf(fid, 'Mean RESP = %f\n', mean_X);

% !! Calculate standard deviation of the signal
std_X = std(X);
fprintf(fid, 'Standard Deviation RESP = %f\n\n', std_X);

% Part b
% !! Generate a normal random variable with the same mean & standard deviation 
R = normrnd(mean_X, std_X, 1, 30000);

% !! Plot pdf and CDF of the generated random variable using pdf_cdf function
% Plot the CDF of the whole data set as the reference (in red color)
figure;  
subplot(2,1,1);
title('CDF');
[p1, xx1] = ecdf(R);
plot(xx1,p1);
xlabel('X');
ylabel('Probability');
%hold on;% For the next plots to be on the same figure        
h = get(gca,'children'); set(h,'LineWidth',2);set(h,'Color','r')
pdf_cdf(R);
title(strcat(char(labels(3)),' Normal Approximation'));


% Part c
figure;
title(strcat(char(labels(3)),' Normplot'));
% !! Use normplot function to estimate the difference between distributions
normplot(X)
fprintf(fid, 'Task 1.2c\n\n');
fprintf(fid, 'The dataset generated in this part is normally distributed, but the dataset from 1.1\n'); 
fprintf(fid, 'is right-skewed. In the dataset from 1.1, the variable X is approximately normally\n');
fprintf(fid, 'distributed when 12 <= X <= 38, but not normally distributed when X<12 or X>38. \n\n');


% Part d
% !! Show your work in the report, then plug in the numbers that you calculated here
fprintf(fid, 'Task 1.2d\n\n');
fprintf(fid, 'PDF of normal distribution: \n');
fprintf(fid, 'f(x) = 1/(%f * sqrt(2*Pi)) * exp(-0.5*((x-%f)/%f)^2) \n', std_X, mean_X, std_X);
fprintf(fid, 'CDF of normal distribution: \n');
fprintf(fid, 'F(x) = 1/(sqrt(2*Pi)) * Integrate for t from -infinity to (x-%f)/%f { exp(-0.5* t^2) dt} \n\n', mean_X, std_X);

z_score = 2.055;
ther_a = mean_X - z_score*std_X;
ther_b = mean_X + z_score*std_X;

fprintf(fid, 'Theoretical a = %f\n', ther_a);
fprintf(fid, 'Theoretical b = %f\n\n', ther_b);
fprintf(fid, 'Theoretical a and b are both a little bit less than the empirical a and b.\n');
fprintf(fid, 'This is probably because our actual dataset from 1.1 is right-skewed, \n');
fprintf(fid, 'whereas a normal distribution is not skewed.\n');

fprintf(fid, '\n\nGROUP DISTRIBUTION:\n\n');

fprintf(fid, 'Harsh Modhera (hmodhe2) - 33.33 percent\n');
fprintf(fid, 'Herman Pineda (hpineda2) - 33.33 percent\n');
fprintf(fid, 'Yuchen Li (li215) - 33.33 percent\n\n');

fprintf(fid, 'We all met up in Grainger basement on Mar 4 and worked through all of the tasks together.\n');

%fclose(fid);

%% Task 2.1;

% Tasks 2.1 and 2.2 should be done twice, 
% once with the empirical threshold, and once with the theoretical threshold
% !! Change the code to do this.

% Part a
% !! Call the threshold function and generate alarms for each signal

HR_alarm_EM = threshold_func(HR, 80.17, 98.52);
PR_alarm_EM = threshold_func(PR, 79.00, 97.07);
X_alarm_EM = threshold_func(X, 10.146654, 37.085962);


% Parts b and c
% !! Write the code for coalescing alarms and majority voting here 

HR_alarm_EM_Coal = coalesce(HR_alarm_EM);
PR_alarm_EM_Coal = coalesce(PR_alarm_EM);
X_alarm_EM_Coal = coalesce(X_alarm_EM);

Voted_Alarm_EM = vote(HR_alarm_EM_Coal, PR_alarm_EM_Coal, X_alarm_EM_Coal);

% Part d
% !! Fill in the bar functions with the name of vectors storing your alarms
figure;
subplot(5,1,1);
bar(HR_alarm_EM_Coal);
title(strcat(char(labels(1)),' Alarms'));
subplot(5,1,2);
bar(PR_alarm_EM_Coal);
title(strcat(char(labels(2)),' Alarms'));
subplot(5,1,3);
bar(X_alarm_EM_Coal);
title(strcat(char(labels(3)),' Alarms'));
subplot(5,1,4);
bar(Voted_Alarm_EM);
title('Majority Voter Alarms - Empirical Thresholds');
subplot(5,1,5);
title('Golden Alarms');
bar(golden_alarms,'r');

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

HR_alarm_TH = threshold_func(HR, 78.84, 96.83);
PR_alarm_TH = threshold_func(PR, 78.15, 96.09);
X_alarm_TH = threshold_func(X, 7.142497, 36.341138);

HR_alarm_TH_Coal = coalesce(HR_alarm_TH);
PR_alarm_TH_Coal = coalesce(PR_alarm_TH);
X_alarm_TH_Coal = coalesce(X_alarm_TH);

Voted_Alarm_TH = vote(HR_alarm_TH_Coal, PR_alarm_TH_Coal, X_alarm_TH_Coal);


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