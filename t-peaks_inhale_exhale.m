%% Determine T-peaks Inhale/Exhale

% EEGLAB toolbox required

inhaleexhale = readtable('inhale_exhale_exteroception.xlsx');
inhaleexhale = table2array(inhaleexhale);

for i = 1:length(EEG.event)
    
    EEG.event(i).type = strrep(EEG.event(i).type, 'ECG', '5');
    
end

ecg_t_events = [];

for i = 1 : length(EEG.event)
    
        if EEG.event(i).type == '5'

        ecg_t_events = [ecg_t_events; EEG.event(i).latency];
        
        end
end

ecg_t_events_time = ecg_t_events / EEG.srate;

%% T-pekas Inhale

inhale_end_time = inhaleexhale(:,2);
inhale_start_time = inhaleexhale(:,1);

inhale_peaks = [];

for i = 1 : length(inhale_start_time)
    
index_ecg_t_inhale = find(ecg_t_events_time < inhale_end_time(i) & ecg_t_events_time > inhale_start_time(i));

ecg_t_inhale = ecg_t_events_time(index_ecg_t_inhale);

inhale_peaks = [inhale_peaks; ecg_t_inhale];

end

%% T-pekas Enhale

exhale_end_time = inhaleexhale(:,4);
exhale_start_time = inhaleexhale(:,3);

exhale_peaks = [];

for i = 1 : length(exhale_start_time)
    
index_ecg_t_exhale = find(ecg_t_events_time < exhale_end_time(i) & ecg_t_events_time > exhale_start_time(i));

ecg_t_exhale = ecg_t_events_time(index_ecg_t_exhale);

exhale_peaks = [exhale_peaks; ecg_t_exhale];

end

%% Export

inhale_peaks = num2cell(inhale_peaks);
exhale_peaks = num2cell(exhale_peaks);

inhale_peaks(:,2) = {'inhale_peaks'};
exhale_peaks(:,2) = {'exhale_peaks'};

event_list_t = [inhale_peaks; exhale_peaks];

writecell(event_list_t,'event_list_t.txt');

