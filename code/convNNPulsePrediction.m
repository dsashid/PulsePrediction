function [X,Y,AUC_train] =convNNPulsePrediction(scalogram_data,labels_training,CPRflag)
%creates convolutional NN for comparison based on reshaped scalogram
%INPUTS: Xtrain: training scalograms that are later reshaped into original
%form
%labels_training:training labels for pulse/pulseless
%CPR flag: 1 if CPR, 0 if no CPR
%X,Y: for confidence intervals
%AUC_train: training AUC for convNN
%=================================================

num_pulse_train = 211;
num_noPulse_train = 329;
n_pulse = 351;

Xtrain_pulse = scalogram_data(:,1:num_pulse_train);
Xtrain_noPulse = scalogram_data(:,n_pulse+1:n_pulse+num_noPulse_train);
Xtrain = [Xtrain_pulse Xtrain_noPulse];

%reshape so 4d arrays:

%with CPR
if (CPRflag ==1)
    Xtrain_reshaped = reshape(Xtrain,[53,2500,1,540]);
    cnn_rows = 53;
    cnn_col = 2500;
end

%without CPR
if (CPRflag==0)
    Xtrain_reshaped = reshape(Xtrain,[44,1252,1,540]);
    cnn_rows = 44;
    cnn_col = 1252;
end

%create layers
layers = [imageInputLayer([cnn_rows cnn_col 1]);
    convolution2dLayer(5,16);
    reluLayer();
    maxPooling2dLayer(2,'Stride',2);
    fullyConnectedLayer(2);
    softmaxLayer();
    classificationLayer()];

%training options
options = trainingOptions('sgdm',...
        'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.2, ...
    'LearnRateDropPeriod',5, ...,
    'MaxEpochs',20);


%for reproducibility
rng(1)

%train
net = trainNetwork(Xtrain_reshaped, categorical(labels_training'), layers, options);

%training AUCs
[YPred,scores]=classify(net,Xtrain_reshaped);
[X,Y,T,AUC_train,optL] = perfcurve(labels_training,scores(:,2),1);


end