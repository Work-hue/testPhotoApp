% FILL IN / MODIFY THE CODE WITH "" or comments with !!

clear all
close all
clc

% ----- START OF TASK 0 -----

load('monitor_alarms.mat');
data = MonitorAlarms;

% remove single quotes from the time data

data.StartTime = strrep(data.StartTime, '''', ''); 
data.StopTime = strrep(data.StopTime, '''', '');

% open the result file
% !! replace # with your own groupID

fid = fopen('ECE313_Mini1_group20', 'w');

% !! subset your data for each alarm_type

data_SYSTEM = data(ismember(data.Alarm_Type, 'SYSTEM'), :);
data_WARNING = data(ismember(data.Alarm_Type, 'WARNING'), :);
data_CRISIS = data(ismember(data.Alarm_Type, 'CRISIS'), :);
data_ADVISORY = data(ismember(data.Alarm_Type, 'ADVISORY'), :);

% ----- START OF TASK 1 -----

% T1.1 

% !! count the number of alarms for each alarm_type

num_elem_SYSTEM = height(data_SYSTEM);
num_elem_WARNING = height(data_WARNING);
num_elem_CRISIS = height(data_CRISIS);
num_elem_ADVISORY = height(data_ADVISORY);

% !! calaculate the probability for each alarm_type

total_alarms = num_elem_SYSTEM + num_elem_WARNING + num_elem_CRISIS + num_elem_ADVISORY;
prob_sys_alarms = num_elem_SYSTEM / total_alarms;
prob_warn_alarms = num_elem_WARNING / total_alarms;
prob_cris_alarms = num_elem_CRISIS / total_alarms;
prob_adv_alarms = num_elem_ADVISORY / total_alarms;

fprintf(fid, 'Task 1.1\n\n');
fprintf(fid, 'P(SYSTEM) = %f\n', prob_sys_alarms);
fprintf(fid, 'P(ADVISORY) = %f\n', prob_adv_alarms);
fprintf(fid, 'P(WARNING) = %f\n', prob_warn_alarms);
fprintf(fid, 'P(CRISIS) = %f\n\n', prob_cris_alarms);

A = categorical(data.Cause);
summary(A);

prob_cause1 = 2404 / total_alarms; 
prob_cause2 = 1883 / total_alarms;
prob_cause3 = 859 / total_alarms;

fprintf(fid, 'P(LOW_OXY_SAT) = %f\n', prob_cause1);
fprintf(fid, 'P(APP_ERR) = %f\n', prob_cause2);
fprintf(fid, 'P(NW_ERR) = %f\n', prob_cause3);

% T1.2 

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

% T1.3

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

% ----- START OF TASK 2 -----

% T2.1a 

cause_SYSTEM = {'APP_ERR', 'SIG_ARTIFACT', 'LEADS_FAILURE', 'NW_ERR'};

fprintf(fid, '\n\nTask 2.1a\n\n');

fprintf(fid, 'Probability of causes for SYSTEM alarms\n\n');

for i=1:4,
    % !! subset your data
    % !! do the counts to derive your answers
    
    data_SYSTEM_CAUSE = data_SYSTEM(ismember(data_SYSTEM.Cause, cause_SYSTEM(i)), :);
   
    fprintf(fid, 'P(%s) = %f\n', cell2mat(cause_SYSTEM(i)), height(data_SYSTEM_CAUSE)/height(data_SYSTEM));
end

% T2.1b

fprintf(fid, '\n\nTask 2.1b\n\n');

data_APP_ERR = data(ismember(data.Cause, 'APP_ERR'), :);
data_APP_ERR_SYSTEM = data_APP_ERR(ismember(data_APP_ERR.Alarm_Type, 'SYSTEM'), :);

fprintf(fid, 'P(SYSTEM | APP_ERR) = %f\n', height(data_APP_ERR_SYSTEM)/height(data_APP_ERR));
fprintf(fid, 'P(APP_ERR | SYSTEM) = 0.637441\n\n');

fprintf(fid, 'P(SYSTEM | APP_ERR) and P(APP_ERR | SYSTEM) are different.\n'); 
fprintf(fid, 'Given it is an APP_ERR, it must be a SYSTEM warning,\n'); 
fprintf(fid, 'because APP_ERR is a subset of SYSTEM warning.\n');
fprintf(fid, 'However given it is a SYSTEM warning, it is not necessarily an APP_ERR,\n');
fprintf(fid, 'because it could also be SIG_ARTIFACT, LEADS_FAILURE, or NW_ERR.\n');

% T2.2

% !! Using the results from Task 2.1, derive the probability

fprintf(fid, '\n\nTask 2.2\n\n');

fprintf(fid, 'P(APP_ERR and SYSTEM) = P(APP_ERR | SYSTEM) * P(SYSTEM) = %f\n', 0.637441 * 0.518428);

% T2.3a

% !! Calculate the duration for each alarms
% make sure that the durations are in seconds

fprintf(fid, '\n\nTask 2.3a\n\n');

x_h = str2num(datestr(data.StartTime, 'HH'));
x_m = str2num(datestr(data.StartTime, 'MM'));
x_s = str2num(datestr(data.StartTime, 'SS.FFF'));

y_h = str2num(datestr(data.StopTime, 'HH'));
y_m = str2num(datestr(data.StopTime, 'MM'));
y_s = str2num(datestr(data.StopTime, 'SS.FFF'));

data.Duration = (y_h - x_h)*3600 + (y_m - x_m)*60 + (y_s - x_s);

data_SYSTEM = data(ismember(data.Alarm_Type, 'SYSTEM'), :);
data_WARNING = data(ismember(data.Alarm_Type, 'WARNING'), :);
data_CRISIS = data(ismember(data.Alarm_Type, 'CRISIS'), :);
data_ADVISORY = data(ismember(data.Alarm_Type, 'ADVISORY'), :);

avg_dur_sys = sum(data_SYSTEM.Duration) / num_elem_SYSTEM;
avg_dur_warn = sum(data_WARNING.Duration) / num_elem_WARNING;
avg_dur_cris = sum(data_CRISIS.Duration) / num_elem_CRISIS;
avg_dur_adv = sum(data_ADVISORY.Duration) / num_elem_ADVISORY;

fprintf(fid, 'The average duration of system alarms is %f seconds.\n', avg_dur_sys);
fprintf(fid, 'The average duration of warning alarms is %f seconds.\n', avg_dur_warn);
fprintf(fid, 'The average duration of crisis alarms is %f seconds.\n', avg_dur_cris);
fprintf(fid, 'The average duration of advisory alarms is %f seconds.\n', avg_dur_adv);

% T2.3b

fprintf(fid, '\n\nTask 2.3b\n\n');

alarmDurByHour = zeros(24,2);

for i = 0:23
    alarmDurByHour(i+1,1) = i; 
    temp_table = data(ismember(data.Hours, i), :);
    sumByHour = sum(temp_table.Duration);
    alarmDurByHour(i+1,2) = sumByHour / height(temp_table);
end

% Print the result

for i = 1:10
    % !! Count the number of alarms for the given hour(i)
    fprintf(fid, 'Hour: %d\t\t\t Average Duration For Alarms: %f seconds\n', alarmDurByHour(i,1), alarmDurByHour(i,2));
end

for i = 11:24
    % !! Count the number of alarms for the given hour(i)
    fprintf(fid, 'Hour: %d\t\t Average Duration For Alarms: %f seconds\n', alarmDurByHour(i,1), alarmDurByHour(i,2));
end

% T2.3c

% !! Draw a bar chart to plot the average duration per hour

figure;
bar(alarmDurByHour(:,1),alarmDurByHour(:,2));

% label the plot

title('Average Duration For Each Hour of the Day');
xlabel('Hour');
ylabel('Average Duration (in Seconds)');

% ----- START OF TASK 3 -----

% T3.1

fprintf(fid, '\n\nTask 3.1\n\n');

% !! Define the metric that identifies patients in a severe situation
%fprintf(fid, '(Number of CRISIS alarm *2 + Number of CRISIS alarm) on average per hour');
fprintf(fid, 'Metric:\n patValue = total duration of CRISIS alarm * 1000\n + total duration of WARNING alarm * 100\n + total duration of SYSTEM alarm * 10\n + total duration of ADVISORY alarm * 1\n\n');
fprintf(fid, 'This metric is effective because it establishes different weights to the different alarm types. Crisis alarms\n');
fprintf(fid, 'have the most weight because they are life threatening. The order is crisis, warning, system and advisory alarms.\n');
fprintf(fid, 'The total duration of each alarm type has also been incorporated in this metric because it is a measure of\n');
fprintf(fid, 'how much care/attention the patient is already receiving.\n');

fprintf(fid, '\n\nTask 3.2\n\n');

% !! Using your metric, find the top two patient beds in a severe situation
beds = [921,923,940,942,943,944,946,947,952,953,955,956];
count = zeros(12,6);

for i = 1:12
    count(i,1) = beds(i);
end

fprintf(fid, 'The following is a table describing the number of alarms (of each type) for each bed.\n\n');
fprintf(fid, '\t\t\t\tCRISIS\t\tWARNING\t\tSYSTEM\t\t  ADVISORY\t\t Metric\n\n');    

for i = 1:12
    data_BED = data(ismember(data.Bed_No, beds(1,i)), :);
    
    data_BED_CRISIS = data_BED(ismember(data_BED.Alarm_Type, 'CRISIS'), :);
    data_BED_WARNING = data_BED(ismember(data_BED.Alarm_Type, 'WARNING'), :);
    data_BED_SYSTEM = data_BED(ismember(data_BED.Alarm_Type, 'SYSTEM'), :);
    data_BED_ADVISORY = data_BED(ismember(data_BED.Alarm_Type, 'ADVISORY'), :);    
   
    count(i,2) = height(data_BED_CRISIS);
    count(i,3) = height(data_BED_WARNING);
    count(i,4) = height(data_BED_SYSTEM);
    count(i,5) = height(data_BED_ADVISORY);
    count(i,6) = 1000*sum(data_BED_CRISIS.Duration) + 100*sum(data_BED_WARNING.Duration) + 10*sum(data_BED_SYSTEM.Duration) + 1*sum(data_BED_ADVISORY.Duration);
    
    % print into table format
    if i == 11 
        fprintf(fid, 'Bed No.%d\t\t %d\t\t\t %d\t\t\t %d   \t\t\t %d  \t\t %d\t\t\n', count(i,1), count(i,2), count(i,3), count(i,4), count(i,5), count(i,6));    
    else
        fprintf(fid, 'Bed No.%d\t\t %d\t\t\t %d\t\t\t %d \t\t\t %d  \t\t %d\t\t\n', count(i,1), count(i,2), count(i,3), count(i,4), count(i,5), count(i,6));    
    end
end

% find the two max values

[first, idx1] = max(count(:,6));
metric2 = count(:,6);
metric2(idx1) = 0;
[second, idx2] = max(metric2);
metric3 = metric2;
metric3(idx2) = 0;
[third, idx3] = max(metric3);

fprintf(fid, '\nThe top two patient beds in a serious condition are No.%d and No.%d.\n\n', beds(1,idx1),beds(1,idx2));

% explain the result

fprintf(fid, 'As you can see from the table above, beds 940 and 953 are the top two patients with serious conditions.\n');
fprintf(fid, 'Although bed 940 has the most number of crisis and warning alarms, it is hard to trust this data\n');
fprintf(fid, 'due to the fact that bed 940 also has an excessive amount of system alarms. It is possible that certain\n');
fprintf(fid, 'lab equipment may be defective triggering false alarms. However, the patient at this bed should still\n');
fprintf(fid, 'be checked in case the alarms are intentional. If the alarms are false, and the equipment has been validated \n');
fprintf(fid, 'as defective, the top two patients to consider would be beds 923 and 953. Therefore, from this point on,\n');
fprintf(fid, 'we will be considering the top three patients in need.\n\n');

% !! Extract (split) the data of your interest
pat1 = data(ismember(data.Bed_No, beds(1,idx1)), :);
pat2 = data(ismember(data.Bed_No, beds(1,idx2)), :);
pat3 = data(ismember(data.Bed_No, beds(1,idx3)), :);

% !! Write your own code for analysis (ref. codes for Task1 and Task2)

fprintf(fid, 'Analysis for bed %d:\n\n', pat1.Bed_No(1));

pat1_cris = pat1(ismember(pat1.Alarm_Type, 'CRISIS'), :);
pat1_warn = pat1(ismember(pat1.Alarm_Type, 'WARNING'), :);
pat1_sys = pat1(ismember(pat1.Alarm_Type, 'SYSTEM'), :);
pat1_adv = pat1(ismember(pat1.Alarm_Type, 'ADVISORY'), :);

pat1_cris_tot = height(pat1_cris);
pat1_warn_tot = height(pat1_warn);
pat1_sys_tot = height(pat1_sys);
pat1_adv_tot = height(pat1_adv);

pat1_cris_dur = sum(pat1_cris.Duration) / pat1_cris_tot;
pat1_warn_dur = sum(pat1_warn.Duration) / pat1_warn_tot;
pat1_sys_dur = sum(pat1_sys.Duration) / pat1_sys_tot;
pat1_adv_dur = sum(pat1_adv.Duration) / pat1_adv_tot;

fprintf(fid, '\tTotal Number of CRISIS Alarms: %d\n', pat1_cris_tot);
fprintf(fid, '\t\tAverage Duration (in sec) of CRISIS Alarms: %f\n\n', pat1_cris_dur);
fprintf(fid, '\t\tNumber of COUPLET Alarms: %d\n', 2);
fprintf(fid, '\t\tNumber of HA_BRADY Alarms: %d\n', 2);
fprintf(fid, '\t\tNumber of LOW_OXY_SAT Alarms: %d\n', 51);
fprintf(fid, '\t\tNumber of PAUSE Alarms: %d\n\n', 2);

fprintf(fid, '\tTotal Number of WARNING Alarms: %d\n', pat1_warn_tot);
fprintf(fid, '\t\tAverage Duration (in sec) of WARNING Alarms: %f\n\n', pat1_warn_dur);
fprintf(fid, '\t\tNumber of ATR_FIB Alarms: %d\n', 1);
fprintf(fid, '\t\tNumber of HA_BRADY Alarms: %d\n', 1);
fprintf(fid, '\t\tNumber of LOW_OXY_SAT Alarms: %d\n', 57);
fprintf(fid, '\t\tNumber of PAUSE Alarms: %d\n\n', 1);

fprintf(fid, '\tTotal Number of SYSTEM Alarms: %d\n', pat1_sys_tot);
fprintf(fid, '\t\tAverage Duration (in sec) of SYSTEM Alarms: %f\n\n', pat1_sys_dur);
fprintf(fid, '\t\tNumber of APP_ERR Alarms: %d\n', 779);
fprintf(fid, '\t\tNumber of LEADS_FAILURE Alarms: %d\n', 46);
fprintf(fid, '\t\tNumber of NW_ERR Alarms: %d\n', 336);
fprintf(fid, '\t\tNumber of SIG_ARTIFACT Alarms: %d\n\n', 44);

fprintf(fid, '\tTotal Number of ADVISORY Alarms: %d\n', pat1_adv_tot);
fprintf(fid, '\t\tAverage Duration (in sec) of ADVISORY Alarms: %f\n\n', pat1_adv_dur);
fprintf(fid, '\t\tNumber of ATR_FIB Alarms: %d\n', 3);
fprintf(fid, '\t\tNumber of COUPLET Alarms: %d\n', 4);
fprintf(fid, '\t\tNumber of HA_BRADY Alarms: %d\n', 23);
fprintf(fid, '\t\tNumber of HA_VT_> Alarms: %d\n', 5);
fprintf(fid, '\t\tNumber of HA_V_BRADY Alarms: %d\n', 2);
fprintf(fid, '\t\tNumber of HIGH_PVC Alarms: %d\n', 1);
fprintf(fid, '\t\tNumber of LOW_OXY_SAT Alarms: %d\n', 1237);
fprintf(fid, '\t\tNumber of NA Alarms: %d\n', 3);
fprintf(fid, '\t\tNumber of PAUSE Alarms: %d\n', 9);
fprintf(fid, '\t\tNumber of SLEEP_DISORDER Alarms: %d\n\n', 7);

fprintf(fid, 'Analysis for bed %d:\n\n', pat2.Bed_No(1));

pat2_cris = pat1(ismember(pat2.Alarm_Type, 'CRISIS'), :);
pat2_warn = pat1(ismember(pat2.Alarm_Type, 'WARNING'), :);
pat2_sys = pat1(ismember(pat2.Alarm_Type, 'SYSTEM'), :);
pat2_adv = pat1(ismember(pat2.Alarm_Type, 'ADVISORY'), :);

pat2_cris_tot = height(pat2_cris);
pat2_warn_tot = height(pat2_warn);
pat2_sys_tot = height(pat2_sys);
pat2_adv_tot = height(pat2_adv);

pat2_cris_dur = sum(pat2_cris.Duration) / pat2_cris_tot;
pat2_warn_dur = sum(pat2_warn.Duration) / pat2_warn_tot;
pat2_sys_dur = sum(pat2_sys.Duration) / pat2_sys_tot;
pat2_adv_dur = sum(pat2_adv.Duration) / pat2_adv_tot;

fprintf(fid, '\tTotal Number of CRISIS Alarms: %d\n', pat2_cris_tot);
fprintf(fid, '\t\tAverage Duration (in sec) of CRISIS Alarms: %f\n\n', pat2_cris_dur);
fprintf(fid, '\t\tNumber of COUPLET Alarms: %d\n', 1);
fprintf(fid, '\t\tNumber of HA_V_TACHY Alarms: %d\n', 4);
fprintf(fid, '\t\tNumber of LOW_OXY_SAT Alarms: %d\n\n', 12);

fprintf(fid, '\tTotal Number of WARNING Alarms: %d\n', pat2_warn_tot);
fprintf(fid, '\t\tAverage Duration (in sec) of WARNING Alarms: %f\n\n', pat2_warn_dur);
fprintf(fid, '\t\tNumber of ATR_FIB Alarms: %d\n', 2);
fprintf(fid, '\t\tNumber of COUPLET Alarms: %d\n', 2);
fprintf(fid, '\t\tNumber of HA_BRADY Alarms: %d\n', 44);
fprintf(fid, '\t\tNumber of HA_VT_> Alarms: %d\n', 1);
fprintf(fid, '\t\tNumber of LOW_OXY_SAT Alarms: %d\n', 10);
fprintf(fid, '\t\tNumber of SLEEP_DISORDER Alarms: %d\n\n', 10);

fprintf(fid, '\tTotal Number of SYSTEM Alarms: %d\n', pat2_sys_tot);
fprintf(fid, '\t\tAverage Duration (in sec) of SYSTEM Alarms: %f\n\n', pat2_sys_dur);
fprintf(fid, '\t\tNumber of APP_ERR Alarms: %d\n', 133);
fprintf(fid, '\t\tNumber of LEADS_FAILURE Alarms: %d\n', 9);
fprintf(fid, '\t\tNumber of NW_ERR Alarms: %d\n', 55);
fprintf(fid, '\t\tNumber of SIG_ARTIFACT Alarms: %d\n\n', 6);

fprintf(fid, '\tTotal Number of ADVISORY Alarms: %d\n', pat2_adv_tot);
fprintf(fid, '\t\tAverage Duration (in sec) of ADVISORY Alarms: %f\n\n', pat2_adv_dur);
fprintf(fid, '\t\tNumber of ATR_FIB Alarms: %d\n', 15);
fprintf(fid, '\t\tNumber of COUPLET Alarms: %d\n', 8);
fprintf(fid, '\t\tNumber of HA_BRADY Alarms: %d\n', 4);
fprintf(fid, '\t\tNumber of HA_VT_> Alarms: %d\n', 2);
fprintf(fid, '\t\tNumber of HIGH_PVC Alarms: %d\n', 2);
fprintf(fid, '\t\tNumber of LOW_OXY_SAT Alarms: %d\n', 97);
fprintf(fid, '\t\tNumber of PAUSE Alarms: %d\n', 1);
fprintf(fid, '\t\tNumber of SLEEP_DISORDER Alarms: %d\n\n', 1);

fprintf(fid, 'Analysis for bed %d:\n\n', pat3.Bed_No(1));

pat3_cris = pat3(ismember(pat3.Alarm_Type, 'CRISIS'), :);
pat3_warn = pat3(ismember(pat3.Alarm_Type, 'WARNING'), :);
pat3_sys = pat3(ismember(pat3.Alarm_Type, 'SYSTEM'), :);
pat3_adv = pat3(ismember(pat3.Alarm_Type, 'ADVISORY'), :);

pat3_cris_tot = height(pat3_cris);
pat3_warn_tot = height(pat3_warn);
pat3_sys_tot = height(pat3_sys);
pat3_adv_tot = height(pat3_adv);

pat3_cris_dur = sum(pat3_cris.Duration) / pat3_cris_tot;
pat3_warn_dur = sum(pat3_warn.Duration) / pat3_warn_tot;
pat3_sys_dur = sum(pat3_sys.Duration) / pat3_sys_tot;
pat3_adv_dur = sum(pat3_adv.Duration) / pat3_adv_tot;

fprintf(fid, '\tTotal Number of CRISIS Alarms: %d\n', pat3_cris_tot);
fprintf(fid, '\t\tAverage Duration (in sec) of CRISIS Alarms: %f\n\n', pat3_cris_dur);
fprintf(fid, '\t\tNumber of ATR_FIB Alarms: %d\n', 1);
fprintf(fid, '\t\tNumber of LOW_OXY_SAT Alarms: %d\n\n', 14);

fprintf(fid, '\tTotal Number of WARNING Alarms: %d\n', pat3_warn_tot);
fprintf(fid, '\t\tAverage Duration (in sec) of WARNING Alarms: %f\n\n', pat3_warn_dur);
fprintf(fid, '\t\tNumber of ATR_FIB Alarms: %d\n', 1);
fprintf(fid, '\t\tNumber of HA_BRADY Alarms: %d\n', 1);
fprintf(fid, '\t\tNumber of LOW_OXY_SAT Alarms: %d\n\n', 75);

fprintf(fid, '\tTotal Number of SYSTEM Alarms: %d\n', pat3_sys_tot);
fprintf(fid, '\t\tAverage Duration (in sec) of SYSTEM Alarms: %f\n\n', pat3_sys_dur);
fprintf(fid, '\t\tNumber of APP_ERR Alarms: %d\n', 280);
fprintf(fid, '\t\tNumber of LEADS_FAILURE Alarms: %d\n', 22);
fprintf(fid, '\t\tNumber of NW_ERR Alarms: %d\n', 120);
fprintf(fid, '\t\tNumber of SIG_ARTIFACT Alarms: %d\n\n', 9);

fprintf(fid, '\tTotal Number of ADVISORY Alarms: %d\n', pat3_adv_tot);
fprintf(fid, '\t\tAverage Duration (in sec) of ADVISORY Alarms: %f\n\n', pat3_adv_dur);
fprintf(fid, '\t\tNumber of ATR_FIB Alarms: %d\n', 1);
fprintf(fid, '\t\tNumber of COUPLET Alarms: %d\n', 7);
fprintf(fid, '\t\tNumber of HA_BRADY Alarms: %d\n', 6);
fprintf(fid, '\t\tNumber of LOW_OXY_SAT Alarms: %d\n', 244);
fprintf(fid, '\t\tNumber of NA Alarms: %d\n', 2);
fprintf(fid, '\t\tNumber of PAUSE Alarms: %d\n\n', 1);

% for each patient, plot # of CRISIS & WARNING alarms during each hour

% No. 940
data_BED = data(ismember(data.Bed_No, 940),:);
data_BED_CRISIS = data_BED(ismember(data_BED.Alarm_Type, 'CRISIS'),:).Hours;
data_BED_WARNING = data_BED(ismember(data_BED.Alarm_Type, 'WARNING'),:).Hours;
data_BED_CandW = [data_BED_CRISIS; data_BED_WARNING];

figure;
hist(data_BED_CandW,24);
h1 = findobj(gca,'Type','patch');
h1.FaceColor = [0 0.5 0.5];
h1.EdgeColor = 'w';
title('Histogram of C/W Alarms Per Hour for Bed 940');
xlabel('Hour');
ylabel('Number of Alarms');

% No. 953
data_BED = data(ismember(data.Bed_No, 953),:);
data_BED_CRISIS = data_BED(ismember(data_BED.Alarm_Type, 'CRISIS'),:).Hours;
data_BED_WARNING = data_BED(ismember(data_BED.Alarm_Type, 'WARNING'),:).Hours;
data_BED_CandW = [data_BED_CRISIS; data_BED_WARNING];

figure;
hist(data_BED_CandW,24);
h2 = findobj(gca,'Type','patch');
h2.FaceColor = [0 0.5 0.5];
h2.EdgeColor = 'w';
title('Histogram of C/W Alarms Per Hour for Bed 953');
xlabel('Hour');
ylabel('Number of Alarms');

% No. 923
data_BED = data(ismember(data.Bed_No, 923),:);
data_BED_CRISIS = data_BED(ismember(data_BED.Alarm_Type, 'CRISIS'),:).Hours;
data_BED_WARNING = data_BED(ismember(data_BED.Alarm_Type, 'WARNING'),:).Hours;
data_BED_CandW = [data_BED_CRISIS; data_BED_WARNING];

figure;
hist(data_BED_CandW,24);
h3 = findobj(gca,'Type','patch');
h3.FaceColor = [0 0.5 0.5];
h3.EdgeColor = 'w';
title('Histogram of C/W Alarms Per Hour for Bed 923');
xlabel('Hour');
ylabel('Number of Alarms');

% T3.3a

fprintf(fid, 'Here are our 3 observations from this patient data subset.\n\n');

fprintf(fid, 'OBSERVATION 1:\n');
fprintf(fid, 'The top cause of all patients crisis alarm was found to be LOW_OXY_SAT.\n');
fprintf(fid, 'This data is an indicator that these patients often have issues with low\n');
fprintf(fid, 'blood oxygen levels. To reduce the frequency of this alarm cause, a suggestion\n');
fprintf(fid, 'would be to increase oxygen supplementation to patients with such conditions.\n\n');

fprintf(fid, 'OBSERVATION 2:\n');
fprintf(fid, 'The patient at bed 953 has a longer average duration for the warning alarm compared with those at beds 940 and 923.\n');
fprintf(fid, 'This is probably because their top causes for the warning alarm are different. \n');
fprintf(fid, 'Specifically, the top cause for the warning alarm is HA_BRADY for the patient at bed 953, \n');
fprintf(fid, 'whereas the top cause for the warning alarm is LOW_OXY_SAT for the other two patients. \n'); 
fprintf(fid, 'From this we can infer that the warning alarm due to LOW_OXY_SAT has a smaller average duration than the warning alarm due to HA_BRADY.\n');
fprintf(fid, 'In addition, unlike the patient at bed 953, those at beds 940 and 923 both have high average durations\n');
fprintf(fid, 'for their crisis alarms.\n\n');

fprintf(fid, 'OBSERVATION 3:\n');
fprintf(fid, 'In the histograms, one can see that the majority of the alarms are triggered \n');
fprintf(fid, 'from around 8am to 11am for bed 940, at around 11am for bed 923, and from 4am to 1pm\n');
fprintf(fid, 'for bed 953. From this data, we can infer that the patients at beds 940 and 923 require\n');
fprintf(fid, 'more attention for their life-threatening conditions before noon. The patient at bed 953\n');
fprintf(fid, 'could benefit from an early morning caregiver.\n\n');

% T3.3b



fclose(fid);