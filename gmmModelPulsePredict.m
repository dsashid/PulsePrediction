function [X,Y,AUC_trainGMM] = gmmModelPulsePredict(input,labels_training)

%for reproducibility
rng(1)
GMmodel = fitgmdist(input,2);

%training AUC
P_train = posterior(GMmodel,input);
[X,Y,T,AUC_trainGMM,optL] = perfcurve(labels_training,P_train(:,1),1);

end

