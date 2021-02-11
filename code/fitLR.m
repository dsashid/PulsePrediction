function [AUC_LR, opt_LR] = fitLR(modes,outcomes)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
mdl_log  = fitglm(modes,outcomes,'Link','logit','Distribution','binomial')
prob_pulse = predict(mdl_log, modes); 

[X,Y,T,AUC_LR, opt_LR] = perfcurve(outcomes, prob_pulse,1);

[AUC_train,AUC_CI]=auc([outcomes prob_pulse],.05)

end

