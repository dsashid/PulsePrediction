function [trainmat_modes,test_modes,labels_training,labels_test] = createTrainTestSets(range,num_pulse_train,n_pulse,num_noPulse_train,n_pulseless,v2)
%UNTITLED10 creates training/test sets that contain temporal modes for each
%ECG
% INPUTS: 
%range: range of modes to train/test on
%num_pulse_train: cutoff for pulse labels in training set
%n_pulse: number of pulse cases in all
%num_noPulse_train: cutoff for pulseless labels in training set
%n_pulseless: number of pulseless cases in all

%OUTPUTS:
%trainmat_modes: training matrix with temporal modes for each case,
%comprised of training cases of length num_pulse_train and test cases of
%length num_noPulse_train
%test_modes: test matrix with temporal modes for each case,comprised of test 
%cases of length num_pulse_test and test cases of length num_noPulse_test
%=================================================

%number of test cases with pulse label
num_pulse_test = n_pulse - num_pulse_train;

%number of test cases with pulseless label
num_noPulse_test = n_pulseless - num_noPulse_train;


%set up training data
pulseTrain = v2(1:num_pulse_train, range);
pulselessTrain = v2(n_pulse+1:n_pulse+num_noPulse_train,range);
trainmat_modes = [pulseTrain; pulselessTrain];
   
%set up test data
pulseTest = v2(num_pulse_train+1:n_pulse,range);
pulselessTest = v2(n_pulse+num_noPulse_train+1:n_pulse+n_pulseless,range);
test_modes = [pulseTest; pulselessTest];

%labels for training
labels_training = [ones(num_pulse_train,1); zeros(num_noPulse_train,1)];

%labels for test
labels_test=[ones(num_pulse_test,1); zeros(num_noPulse_test,1)]; 

end

