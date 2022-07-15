%% Respiration analysis

% EEGLAB toolbox required
% Breathmetrics toolbox required

% Initialize Breathmetrics

rootDir='C:\Users\User\Desktop\MATLAB\breathmetrics-master';
respDataFileName='xxx_respiratory_data.mat';

addpath('C:\Users\User\Desktop\MATLAB\breathmetrics-master');
addpath('C:\Users\User\Desktop\MATLAB\breathmetrics-master\breathmetrics_functions');
addpath('C:\Users\User\Desktop\MATLAB\breathmetrics-master\img');

resp = EEG.data(66,:); % select respiratory signal (channel 66)
srate = EEG.srate;
respiratoryRecording = resp;
dataType = 'humanAirflow';

bmObj = breathmetrics(respiratoryRecording, srate, dataType);

%% Respiration baseline correction - smoothing

verbose=1;
baselineCorrectionMethod = 'sliding';
zScore=0;
bmObj.correctRespirationToBaseline(baselineCorrectionMethod, zScore, verbose)

% Plot smoothed respiratory signal
PLOT_LIMITS = 1:15360; % select time points
figure; hold all;
r=plot(bmObj.time(PLOT_LIMITS),bmObj.rawRespiration(PLOT_LIMITS),'k-');
sm=plot(bmObj.time(PLOT_LIMITS),bmObj.smoothedRespiration(PLOT_LIMITS),'b-');
bc=plot(bmObj.time(PLOT_LIMITS),bmObj.baselineCorrectedRespiration(PLOT_LIMITS),'r-');
legend([r,sm,bc],{'Raw Respiration';'Smoothed Respiration';'Baseline Corrected Respiration'});
xlabel('Time (seconds)');
ylabel('Respiratory Flow');

%% Estimates respiratory features

bmObj.estimateAllFeatures; % in bmObj variable

%% GUI for respiratory data visualization/correction

newBM=bmGui(bmObj);  % reject noisy breaths/save

%% Export

inhale_exhale_inv = [bmObj.inhaleOnsets; bmObj.inhaleOffsets;...
    bmObj.exhaleOnsets; bmObj.exhaleOffsets];

inhale_exhale = inhale_exhale_inv';
inhale_exhale_time = inhale_exhale / srate; % inhalation/exhalation onset/offset

xlswrite('inhale_exhale.xlsx', inhale_exhale_baseline_time);

%% Other respiratory parameters

breaths = length(inhaleexhale);
average_inhale_duration = mean(inhaleexhale(:, 2)) - mean(inhaleexhale(:, 1));
average_exhale_duration = mean(inhaleexhale(:, 4)) - mean(inhaleexhale(:, 3));
average_breath_duration = average_inhale_duration + average_exhale_duration;
breath_frequency = 60 / average_breath_duration;
IE_ratio = average_inhale_duration / average_exhale_duration;

