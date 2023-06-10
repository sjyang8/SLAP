function [accuracy,Kappa,TPR,class] = Excute_SVM2(Data_R, loc_train, CTrain, loc_test, CTest)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function: classification using SVM classifier
%% Data_R: the hyperspectral image data in two-dimensional form, 
%%          Data_R(m,n), m-the number of samples, n-the number of band
%% CTrain: the number of training samples for each class
%% loc_train: locations for training samples
%% loc_test: locations for testing samples
%% CTest: the number of testing samples per class
%% accuracy: the average classification accuracy
%% Kappa: Kappa coefficient
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Data_R = Data_R./max(Data_R(:)); 
DataTrain = Data_R(loc_train, :);
DataTest = Data_R(loc_test, :);
class = Lib_SVM_Classifier(DataTrain, CTrain, DataTest, 1.0);
[accuracy, TPR,Kappa] = confusion_matrix_wei(class, CTest);