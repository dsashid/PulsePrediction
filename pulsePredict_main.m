% PULSEPREDICT_main: Main script that runs analysis for pulse prediction.
%Loads scalograms for CPR and no CPR and then conducts PCA and trains on
%various models such as LDA, QDA, SVM, NN, GMM, and convNN
%Author: Diya Sashidhar
%==================================================
%for CPR
CPR_data=load('scalogramsTrainTest_pulsePredict.mat');
Xtrain_CPR = CPR_data.Xtrain;
Xtest_CPR =CPR_data.Xtest;

%for noCPR
noCPR_data = load('scalogramsTrainTest_pulsePredict_noCPR.mat');
Xtrain_noCPR = noCPR_data.Xtrain;
Xtest_noCPR = noCPR_data.Xtest;
%TODO: Describe format of datasets/labels

%labels: TODO: incorporate this in the dataset
num_pulse_train = 211;
num_pulse_test = 223;
num_noPulse_test= 149;
num_noPulse_train = 329;

%then do analysis
[u,s,v] = calculateSingularValues(Xtotal);

%create bar plot of normalized singular values
plotSingularValues(s);

%create plot of temporal modes
plotTemporalModes(v);

%create histograms of temporal modes
createHistograms(v);

%range of modes to train on 
range =1:3;

%create training and test sets using temporal modes of scalograms
[trainmat_modes,test_modes,labels_training,labels_test] = createTrainTestSets(range,num_pulse_train,n_pulse,num_noPulse_train,n_pulseless);

%train a discrimant model and test on training data. Set trainTestFlag to 2
%and discriminantType to 'Linear' to see validation results
traintestFlag = 1
[X,Y,AUC] = classifyModes(trainmat_mode, test_mode,labels_training,labels_test, discriminantType, train_testFlag);

%compare to GMM
[X,Y,AUC_trainGMM] = gmmModelPulsePredict(input,labels_training);

%compare to NN:
[X,Y,AUC_trainNN] = nnPulsePredict(input,labels_training);

%compare to ConvNN using scalograms, not temporal modes
CPRflag = 1;
[X,Y,AUC_train] =convNNPulsePrediction(Xtrain_CPR,labels_training,CPRflag);

%% option to include heart rate as a feature: 
%NOTE: need actual ECG for this. Cannot use a scalogram 

[HR_vec_train, median_interval_train] = heartRateDetector(X_train);
[HR_vec_test, median_interval_test] = heartRateDetector(X_test);

input = [trainmat_mode,HR_vec_train];

%for Discriminant Analysis
[X,Y,AUC] = classifyModes(input, [test_mode,HR_vec_test],labels_training,labels_test, discriminantType);

%compare to GMM

[X,Y,AUC_trainGMM] = gmmModelPulsePredict(input,labels_training);

%compare to NN:
[X,Y,AUC_trainNN] = nnPulsePredict(input,labels_training);
