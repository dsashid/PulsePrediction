% PULSEPREDICT_main: Main script that runs analysis for pulse prediction.
%Loads scalograms for CPR and no CPR and then conducts PCA and trains on
%various models such as LDA, QDA, SVM, NN, GMM, and convNN
%Author: Diya Sashidhar
%University of Washington
%Date published: July 2020
%==================================================
clear;clc;close all;
%% PARAMETERS
%CPR flag is 1 for CPR artifacted data, 0 for data without CPR
CPRflag = 1;

%start index of pulse clips in training/test set
num_pulse_train = 211;

%index of pulseless clips in training/test set
num_noPulse_train = 329;

%number of pulse clips
n_pulse  = 351;
%number of pulseless clips
n_pulseless = 561;

%% Load data
%for CPR
if (CPRflag ==1)
        CPR_data=load('scalograms_pulsePredict_CPR.mat');
        scalogram_data = CPR_data.Xtotal;
else
%for noCPR
        noCPR_data = load('scalograms_pulsePredict_noCPR.mat');
        scalogram_data = noCPR_data.Xtotal;
end
%TODO: Describe format of datasets/labels

%% PCA
[u,s,v] = calculateSingularValues(scalogram_data);

%create bar plot of normalized singular values
plotSingularValues(s);

%create plot of temporal modes
plotTemporalModes(v,n_pulse);

%create histograms of temporal modes
createHistograms(v,n_pulse);
%% Create training/test Sets
%range of modes to train on 
range =1:3;

%create training and test sets using temporal modes of scalograms
[trainmat_mode,test_mode,labels_training,labels_test] = createTrainTestSets(range,num_pulse_train,n_pulse,num_noPulse_train,n_pulseless,v);

%% Train Model
%train a discrimant model and test on training data. Set trainTestFlag to 2
%and discriminantType to 'Linear' to see validation results
train_testFlag = 1;

%linear/quadratic discriminant
discriminantType = 'Linear';
[X,Y,AUC_linear] = classifyModes(trainmat_mode, test_mode,labels_training,labels_test, discriminantType, train_testFlag);

%compare to GMM
[X,Y,AUC_trainGMM] = gmmModelPulsePredict(trainmat_mode,labels_training);

%compare to NN:
[X,Y,AUC_trainNN] = NN_pulsepredict(trainmat_mode,labels_training);

%compare to ConvNN using scalograms, not temporal modes
[X,Y,AUC_train_CNN] =convNNPulsePrediction(scalogram_data,labels_training,CPRflag);

%% option to include heart rate as a feature: 
%NOTE: need actual ECG to calculate heartrate. Cannot use a scalogram 

[HR_vec_train, median_interval_train] = heartRateDetector(X_train);
[HR_vec_test, median_interval_test] = heartRateDetector(X_test);

input = [trainmat_mode,HR_vec_train];

%for Discriminant Analysis
[X,Y,AUC] = classifyModes(input, [test_mode,HR_vec_test],labels_training,labels_test, discriminantType);

%compare to GMM
[X,Y,AUC_trainGMM] = gmmModelPulsePredict(input,labels_training);

%compare to NN:
[X,Y,AUC_trainNN] = nnPulsePredict(input,labels_training);

