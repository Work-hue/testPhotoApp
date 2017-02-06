% FILL IN / MODIFY THE CODE WITH "" or comments with !!

clear all
clc

% START OF TASK 0

% import monitor_alarms.mat and put it in a 

load('monitor_alarms.mat');
data = MonitorAlarms;

% not that the data is in a table format,
% try the following in the command window:
%   data
%   data(1)
%   data.StartTime
%   data.StartTime(1)
% now you have learned how to access data in the table

% remove single quotes from the time data

data.StartTime = strrep(data.StartTime, '''', ''); 
data.StopTime = strrep(data.StopTime, '''', '');

% open the result file
% !! replace # with your own groupID

fid = fopen('ECE313_Mini1_group20', 'w');

% T1.1
% !! subset your data for each alarm_type

data_SYSTEM = data(ismember(data.Alarm_Type, 'SYSTEM'), :);
data_WARNING = data(ismember(data.Alarm_Type, 'WARNING'), :);
data_CRISIS = data(ismember(data.Alarm_Type, 'CRISIS'), :);
data_ADVISORY = data(ismember(data.Alarm_Type, 'ADVISORY'), :);

% START OF TASK 1

% !! count the number of alarms for each alarm_type

numSYSTEM = height(data_SYSTEM);
numWARNING = height(data_WARNING);
numCRISIS = height(data_CRISIS);
numADVISORY = height(data_ADVISORY);

% !! calaculate the probability for each alarm_type

total_alarms = numSYSTEM + numWARNING + numCRISIS + numADVISORY;
prob_sys = numSYSTEM / total_alarms;
prob_warn = numWARNING / total_alarms;
prob_cris = numCRISIS / total_alarms;
prob_adv = numADVISORY / total_alarms;

fprintf(fid, 'Task 1.1\n\n');
fprintf(fid, 'P(SYSTEM) = %f\n', prob_sys);
fprintf(fid, 'P(ADVISORY) = %f\n', prob_adv);
fprintf(fid, 'P(WARNING) = %f\n', prob_warn);
fprintf(fid, 'P(CRISIS) = %f\n\n', prob_cris);

%dist_causes = unique(data.Cause);
%temp = zeros(18,1);
%dist_causes_prob = [dist_causes(:,1) num2cell(temp(:,1))]

% Apparently there is a function for this.........

A = categorical(data.Cause);
summary(A);

prob_cause1 = 2404 / total_alarms; 
prob_cause2 = 1883 / total_alarms;
prob_cause3 = 859 / total_alarms;

fprintf(fid, 'P(LOW_OXY_SAT) = %f\n', prob_cause1);
fprintf(fid, 'P(APP_ERR) = %f\n', prob_cause2);
fprintf(fid, 'P(NW_ERR) = %f\n', prob_cause3);

% T1.2. 

fprintf(fid, '\n\nTask 1.2\n\n');

numBeds = unique(data.Bed_No);
numBeds = numBeds(1:13);
total_beds = numel(numBeds);

for i=1:total_beds,
    % !! subset your data for the patient bed
    % !! do the counts to derive your answers
    
    temp_data = data(ismember(data.Bed_No, numBeds(i)), :);
    bed_Csys = height(data(ismember(temp_data.Alarm_Type, 'SYSTEM'), :));
    bed_Cwarn = height(data(ismember(temp_data.Alarm_Type, 'WARNING'), :));
    bed_Ccris = height(data(ismember(temp_data.Alarm_Type, 'CRISIS'), :));
    bed_Cadv = height(data(ismember(temp_data.Alarm_Type, 'ADVISORY'), :));
    alarmsPerBed = bed_Csys + bed_Cwarn + bed_Ccris + bed_Cadv;
    
    prob_bedCsys = bed_Csys / alarmsPerBed;
    prob_bedCwarn = bed_Cwarn / alarmsPerBed;
    prob_bedCcris = bed_Ccris / alarmsPerBed;
    prob_bedCadv = bed_Cadv / alarmsPerBed;
    
    fprintf(fid, 'P(Bed %d Choose System) = %f\n', numBeds(i), prob_bedCsys);
    fprintf(fid, 'P(Bed %d Choose Warning) = %f\n', numBeds(i), prob_bedCwarn);
    fprintf(fid, 'P(Bed %d Choose Crisis) = %f\n', numBeds(i), prob_bedCcris);
    fprintf(fid, 'P(Bed %d Choose Advisory) = %f\n\n', numBeds(i), prob_bedCadv);
end

% T1.3.

% !! Split the data in terms of hours of the start time
% Please note that the time format is 'HH:MM:SS.FFF'

fprintf(fid, '\nTask 1.3\n\n');

new_st = str2num(datestr(data.StartTime, 'HH'));
data.Hours = new_st;

alarmsByHour = zeros(24,2);

for i = 0:23
    alarmsByHour(i+1,1) = i; 
    alarmsByHour(i+1,2) = height(data(ismember(data.Hours, i), :));
end

% Print the result

for i = 1:10
    % !! Count the number of alarms for the given hour(i)
    fprintf(fid, 'Hour: %d\t\t Number of Alarms: %d\n', alarmsByHour(i,1), alarmsByHour(i,2));
end

for i = 11:24
    % !! Count the number of alarms for the given hour(i)
    fprintf(fid, 'Hour: %d\t Number of Alarms: %d\n', alarmsByHour(i,1), alarmsByHour(i,2));
end

figure;

% !! plot the histograms of alarms per hour

hist(data.Hours,24);
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0.5 0.5];
h.EdgeColor = 'w';

% Labeling the figure

title('Histogram of Alarms Per Hour');
xlabel('Hour');
ylabel('Number of Alarms');

%% START OF TASK 2

% T2.1 

causeSYSTEM = {'APP_ERR', 'SIG_ARTIFACT', 'LEADS_FAILURE', 'NW_ERR'};


fprintf(fid, '\n\nTask 2.1\n\n');

fprintf(fid, 'Probability of causes for SYSTEM alarms\n');
for i=1:4,
    % !! subset your data
    % !! do the counts to derive your answers
    fprintf(fid, 'P(%s) = %f\n', cell2mat(causeSYSTEM(i)), "PROBABILITY FOR CAUSE(i) and SYSTEM");
end

% T2.2

% !! Using the results from Task 2.1, derive the probability

fprintf(fid, '\n\nTask 2.1\n\n');
fprintf(fid, 'P(LOW_OXY_SAT and SYSTEM) = %f\n', "PROBABILITY OF LOW_OXY_SAT and SYSTEM");

% T2.3

% !! Calculate the duration for each alarms
% make sure that the durations are in seconds

% T2.3.a 

fprintf(fid, '\n\nTask 2.3.a\n\n');
for i=1:"NUMBER OF ALARM TYPES",
    % !! Split the data interms of alarm type
    
    % !! Count the number of alarms for each alarm type
    
    % !! Calculate the average duration of each alarm type
    
    fprintf(fid, 'Average duration for alarm type %s: %f\n', "ALARMTYPE", "AVERAGE_DURATION");
end

% T2.3.b

fprintf(fid, '\n\nTask 2.3.b\n\n');
for i=1:24,
    % Please not that i loop from 1 to 24
    % The hours in the data are from 0 to 23

    % !! Split the data in terms of hours
    
    % !! Calculate the average duration for each hour(i)
    
    fprintf(fid, 'Average duration for hh=%d = %f\n', "HOUR", "AVERAGE DURATION PER HOUR");
end
figure;
% !! Draw a bar chart to plot the average duration per hour

% label the plot
title('Average Duration for each hour of the day');
ylabel('avg duration');
hours = {'00h', '01h', '02h','03h','04h','05h','06h','07h','08h','09h','10h','11h','12h','13h','14h','15h','16h','17h','18h','19h','20h','21h','22h','23h'};
set(gca, 'XTick', 0:23);
set(gca,'XTickLabel',hours);


% START OF TASK 3

% T3.
fprintf(fid, '\n\nTask3\n\n');
% !! Define the metric that identifies patients in a severe situation

% !! Using your metric, find the top two patient beds in a severe situation

% !! Extract (split) the data of your interest

% !! Write your own code for analysis (ref. codes for Task1 and Task2)

fclose(fid);