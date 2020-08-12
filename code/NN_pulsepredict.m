function [X,Y,AUC_trainingNN] = nnPulsePredict(input,labels_training)
%set up layers
net = feedforwardnet([10,10]);
net.layers{1}.transferFcn = 'radbas';
net.layers{2}.transferFcn = 'tansig';

output = labels_training;

%for reproducibility
rng(1)
net = train(net,input',output');

view(net)

% for training AUC
[X,Y,T,AUC_trainingNN,optL] = perfcurve(labels_training,net(input'),1);

end