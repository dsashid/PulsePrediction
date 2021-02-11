function [AUC,optRF, Mdl] = createRF(modes,outcomes)
%CREATERF bags 100 classification trees to prevent overfitting 
%predicts outcome using modes

rng(1); % For reproducibility
%create 100 trees with minleaf size of 50 to reduce noise
Mdl = TreeBagger(60,modes,outcomes,'OOBPrediction','on',...
        'Method','classification', 'MinLeafSize', 180)
oobErrorBaggedEnsemble = oobError(Mdl);
plot(oobErrorBaggedEnsemble)
[predictedOutcomes,scores] = predict(Mdl, modes);
[X,Y, T,AUC, optRF] = perfcurve(outcomes, scores(:,2),1)

[AUC_train,AUC_CI]=auc([outcomes scores(:,2)],.05)
end

