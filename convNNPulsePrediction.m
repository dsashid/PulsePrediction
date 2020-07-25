function [X,Y,AUC_train] =convNNPulsePrediction(Xtrain,labels_training,CPRflag)
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

%reshape so 4d arrays:

%with CPR
if (CPRflag ==1)
    Xtrain_reshaped = reshape(Xtrain,[53,2500,1,540]);
end

%without CPR
if (CPRflag==0)
    Xtrain_reshaped = reshape(Xtrain,[44,1252,1,540]);
end


%create layers
layers = [imageInputLayer([53 2500 1]);
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