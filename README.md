# PulsePrediction
## Overview
The following repository is the supplementary code for "Machine Learning and Feature Engineering for Predicting Pulse Status during Chest Compressions." This code creates a model that predicts pulse status in electrocardiograms (ECGs) of patients undergoing CPR during cardiac arrest. 

## Technology
The following code was generated using MATLAB R2018b.

## Setup
- Clone repository
- Run pulse_predict.main

## Modeling/Visualization
The results of the paper use the following files. 
- pulse_predict.main: main template that runs supplementary functions:
  - calculateSingularValues.m : runs principal component analysis (PCA) on scalogram data and generates modes
  - plotSingularValues.m : plots normalized singular values/percent variance
  - plotTemporalModes.m : plots first three temporal modes of PCA and projects onto 3D space
  - createHistograms.m : generates histograms for modes with and without pulse
  - createTrainTestSets.m : 
  - classifyModes.m: classifies modes using discriminant model
  - convNNPulsePrediction.m : classifies scalograms using convolutional NN
  - gmmModelPulsePredict.m : classifies modes using GMM
  - NN_pulsepredict.m : classifies modes using NN
  - heartRateDetector: calculates heart rate by using number of QRS complexes and multiplying by corresponding factor

Note: to run heartRateDetector, you must need a 10 second ECG clip. heartRateDetector does not work on scalogram data.
