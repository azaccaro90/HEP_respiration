%% Task accuracy

clear; clc;

% import E-Prime R-peaks events (parallel port)
event_ECG = readtable('event_ECG.xlsx');
event_ECG = table2array(event_ECG);
event_ECG_time = event_ECG;

% import E-prime tapping events (SRBOX press)
tapping_time = readtable('tapping_time.xlsx');
tapping_time = table2array(tapping_time);

% import respiratory phases onset/offest
inhaleexhale = readtable('inhale_exhale.xlsx');
inhaleexhale = table2array(inhaleexhale);

%% Heart rate

frequency_all = [];

for i = 1:length(event_ECG_time) - 1
    
   diff_heartbeats = ((event_ECG_time(i + 1)- event_ECG_time(i)) / 1000); % in ms
   
   frequency_all = [frequency_all; (60 / (diff_heartbeats))];

end

frequency_all = [frequency_all; mean(frequency_all)];

event_ecg_frequency = [event_ECG_time, frequency_all]; % R-peaks + instantaneus frequency


%% Task accuracy

total_correct_69 = [];
total_correct_betw = [];
total_correct_94 = [];
values = [];
values_2 = [];
values_3 = [];
recorded_heartbeats = length(event_ECG_time);

 for k = 1 : recorded_heartbeats
     
     temp = event_ECG_time(k) - tapping_time;
     
     if frequency_all(k) < 69.76 % HR < 69.75
         values = find(temp <= 0 & temp >= -750);
     elseif 69.75 < frequency_all(k) && frequency_all(k) <= 94.25 % 69.75 < HR < 94.25
         values_2 = find(temp <= 0 & temp >= -600);
     elseif frequency_all(k) > 94.25 % HR > 94.25
         values_3 = find(temp <= 0 & temp >= -400);
     end
     
     if values >= 1
           total_correct_69 = [total_correct_69; values(end)];
     elseif values_2 >= 1
           total_correct_betw = [total_correct_betw; values_2(end)];
     elseif values_3 >= 1
           total_correct_94 = [total_correct_94; values_3(end)];
     end
     
     values = [];
     values_2 = [];
     values_3 = [];
     
 end

rec = recorded_heartbeats;
corr_69 = length(total_correct_69); % HR < 69.75
corr_betw = length(total_correct_betw); % 69.75 < HR < 94.25
corr_94 = length(total_correct_94); % HR > 94.25
corr = corr_69 + corr_betw + corr_94;
accuracy = 1 - (abs(rec - corr)/rec); % task accuracy

%% Inhale

inhale_end = inhaleexhale(:,2);
inhale_start = inhaleexhale(:,1);

inhale_start_time = [];

for i = 1:length(inhale_start)
    
   inhale_start_time = [inhale_start_time; inhale_start(i) * 1000]; % in ms

end

inhale_end_time = [];

for i = 1:length(inhale_end)
    
   inhale_end_time = [inhale_end_time; inhale_end(i) * 1000]; % in ms

end

%% Inhale R-peaks

inhale = [];

for i = 1:length(inhale_start_time)
    
index_event_ecg_frequenze = find(event_ecg_frequency < inhale_end_time(i) & event_ecg_frequency > inhale_start_time(i));
event_egc_peak = event_ecg_frequency(index_event_ecg_frequenze,:);

inhale = [inhale; event_egc_peak];

end

inhale_peaks = inhale(:,1);
inhale_freq = inhale(:,2);

mean_inhale_freq = mean(inhale_freq); % mean HR during inhalation

%% Accuracy inhale

total_correct_69_inhale = [];
total_correct_betw_inhale = [];
total_correct_94_inhale = [];
values = [];
values_2 =[];
values_3 =[];
recorded_heartbeats_inhale = length(inhale_peaks);

 for k = 1 : recorded_heartbeats_inhale
     
     temp = inhale_peaks(k) - tapping_time;
     
     if inhale_freq(k) < 69.76
        values = find(temp <= 125 & temp >= -750);
     elseif 69.75 < inhale_freq(k) && inhale_freq(k) <= 94.25 
        values_2 = find(temp <= 100 & temp >= -600);
     elseif inhale_freq(k) > 94.25
        values_3 = find(temp <= 75 & temp >= -400);
     end
     
     if values >= 1
        total_correct_69_inhale = [total_correct_69_inhale; values(end)];
     elseif values_2 >= 1
        total_correct_betw_inhale = [total_correct_betw_inhale; values_2(end)];
     elseif values_3 >= 1
        total_correct_94_inhale = [total_correct_94_inhale; values_3(end)];
     end
     
     values = [];
     values_2 = [];
     values_3 = [];
     
 end

rec_inhale = recorded_heartbeats_inhale;
corr_69_inhale = length(total_correct_69_inhale);
corr_betw_inhale = length(total_correct_betw_inhale);
corr_94_inhale = length(total_correct_94_inhale);
corr_inhale = corr_69_inhale + corr_betw_inhale + corr_94_inhale;
accuracy_inhale = 1 - (abs(rec_inhale - corr_inhale)/rec_inhale); % task accuracy during inhalation


%% Exhale

exhale_end = inhaleexhale(:,4);
exhale_start = inhaleexhale(:,3);

exhale_start_time = [];

for i = 1:length(exhale_start)
    
   exhale_start_time = [exhale_start_time; exhale_start(i) * 1000]; % in ms

end

exhale_end_time = [];

for i = 1:length(exhale_end)
    
   exhale_end_time = [exhale_end_time; exhale_end(i) * 1000]; % in ms

end

%% Exhale R-peaks

exhale = [];

for i = 1:length(exhale_start_time)
    
index_event_ecg_frequenze = find(event_ecg_frequency < exhale_end_time(i) & event_ecg_frequency > exhale_start_time(i));

event_egc_peak = event_ecg_frequency(index_event_ecg_frequenze,:);

exhale = [exhale; event_egc_peak];

end

exhale_peaks = exhale(:,1);
exhale_freq = exhale(:,2);

mean_exhale_freq = mean(exhale_freq); % mean HR during exhalation

%% Accuracy exhale

% calcola accuratezza exhale

total_correct_69_exhale = [];
total_correct_betw_exhale = [];
total_correct_94_exhale = [];
values = [];
values_2 =[];
values_3=[];
recorded_heartbeats_exhale = length(exhale_peaks);

 for k=1:recorded_heartbeats_exhale
     
     temp = exhale_peaks(k)- tapping_time;
     
     if exhale_freq(k) < 69.76
        values = find(temp <= 125 & temp >= -750);
     elseif 69.75 < exhale_freq(k) && exhale_freq(k) <= 94.25 
        values_2 = find(temp <= 100 & temp >= -600);
     elseif exhale_freq(k) > 94.25
        values_3 = find(temp <= 75 & temp >= -400);
     end
     
     if values >= 1 
        total_correct_69_exhale = [total_correct_69_exhale; values(end)];
     elseif values_2 >= 1
        total_correct_betw_exhale = [total_correct_betw_exhale; values_2(end)];
     elseif values_3 >= 1
        total_correct_94_exhale = [total_correct_94_exhale; values_3(end)];
     end
     
     values = [];
     values_2 = [];
     values_3 = [];
     
 end

rec_exhale = recorded_heartbeats_exhale;
corr_69_exhale = length(total_correct_69_exhale);
corr_betw_exhale = length(total_correct_betw_exhale);
corr_94_exhale = length(total_correct_94_exhale);
corr_exhale = corr_69_exhale + corr_betw_exhale + corr_94_exhale;
accuracy_exhale = 1 - (abs(rec_exhale - corr_exhale)/rec_exhale); % task accuracy during exhalation

