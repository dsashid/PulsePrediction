function [X,Y,AUC] = classifyModes(trainmat_mode, test_mode,labels_training,labels_test, discriminantType,train_testFlag)
%CLASSIFYMODES trains a model with temporal modes and tests performance using AUC as a metric.
%   INPUTS: 
%trainmat_mode: training matrix with temporal modes
%test_mode: test matrix with temporal modes
%labels_training: vector with training labels (pulse =1, pulseless = 0)
%labels_training: vector with test labels (pulse = 1, pulseless = 0)
%discriminant type: can choose between 'Linear', 'Quadratic,' and 'SVM' to
%train a LDA, QDA, SVM respectively
%train_testFlag: if 1, then classifies training data, if 2 evalulates test
%data

%OUTPUTS:
%X,Y: for confidence intervals
%AUC: corresponding AUC value
%=============================================================

%for LDA on training data
if (discriminantType == 'Linear' && train_testFlag ==1)
    [~,~,POSTERIOR] = classify(trainmat_mode, trainmat_mode, labels_training, 'Linear');
    [X,Y,T,AUC,~] = perfcurve(labels_training,POSTERIOR(:,2),1);
end 

%for QDA on training data
if (discriminantType == 'Quadratic' && train_testFlag ==1)
    [~,~,POSTERIOR_quad] = classify(trainmat_mode, trainmat_mode, labels_training, 'Quadratic');
    [X,Y,T,AUC,~] = perfcurve(labels_training, POSTERIOR_quad(:,2),1);
end 

%for SVM on training data
if (discriminantType == 'SVM' && train_testFlag ==1)
    Mdl = fitcsvm(trainmat_mode,labels_training,'OptimizeHyperparameters','auto');
    [test_labels,score] = predict(Mdl,trainmat_mode);
    [X,Y,T,AUC,optSVM] = perfcurve(labels_training,score(:,2), 1);
end 


%for LDA test data on test data
if (discriminantType == 'Linear' && train_testFlag ==2)
    [~,~,POSTERIOR] = classify(trainmat_mode, trainmat_mode, labels_training, 'Linear');
    [X,Y,T,AUC,~] = perfcurve(labels_training,POSTERIOR(:,2),1);
end 

end

