function [Train_Test,accracy_SVM1,TPR_SVM1,Kappa_SVM1,accracy_SVM2,TPR_SVM2,Kappa_SVM2,Predict_SVM1,Predict_SVM2,time_result] = my_Classification_V2_CK_ratio_single_iter2_pl_fix_train_label_t(org_data,re_data,GT_map,ith_iter,img_name,ratio,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% function: compare the classification performance on org_data and re_data using SVM and SVM_CK classifier
%% Input:
    %% org_data: original hyperspectral image
    %% re_data: processed hyperspectral image
    %% GT_map: classification Ground-truth map
    %% iter: randomly run 'iter' times
%% Output:
    %% OA_SVM1: average Overall accuracy by SVM classifier on org_data;
    %% OA_SVM2 average Overall accuracy by SVM classifier on re_data;
    %% AA_SVM1: average Average accuracy by SVM classifier on org_data;
    %% AA_SVM2 average Average accuracy by SVM classifier on re_data;
    %% ave_Kappa_SVM1: average Kappa coefficient by SVM classifier on org_data;
    %% ave_Kappa_SVM2 average Kappa coefficient by SVM classifier on re_data;
    %% ave_TPR_SVM1: average accuracy of every class by SVM classifier on org_data;
    %% ave_TPR_SVM2 average accuracy of every class by SVM classifier on re_data;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_start=tic;

[m n d] = size(org_data);
Data_R1 = reshape(org_data,m*n,d);
Data_R2 = reshape(re_data,m*n,d);
accracy_SVM1 = [];
accracy_SVM2 = [];
Kappa_SVM1 = [];
Kappa_SVM2 = [];
%% 
Predict_SVM1=[];
Predict_SVM2=[];
%%
TPR_SVM1 = [];
TPR_SVM2 = [];
%%

time_end1=toc(time_start);


Train_Test=load_loc_train_test_ratio_fix_train_label(img_name,ith_iter,ratio,para,GT_map);
loc_train=Train_Test.loc_train;
loc_test=Train_Test.loc_test;
CTest=Train_Test.CTest;
CTrain=Train_Test.CTrain;
%% SVM
[accur11, Kappa11,TPR11,Predict11] = Excute_SVM2(Data_R1, loc_train, CTrain, loc_test, CTest);
accracy_SVM1 = [accracy_SVM1 accur11];
TPR_SVM1 = [TPR_SVM1;TPR11];
Kappa_SVM1 = [Kappa_SVM1 Kappa11];
Predict_SVM1= [Predict_SVM1 Predict11];

[accur12, Kappa12,TPR12,Predict12] = Excute_SVM2(Data_R2, loc_train, CTrain, loc_test, CTest);
accracy_SVM2 = [accracy_SVM2 accur12];
TPR_SVM2 = [TPR_SVM2;TPR12];
Kappa_SVM2 = [Kappa_SVM2 Kappa12];
Predict_SVM2= [Predict_SVM2 Predict12];

time_end2=toc(time_start);
time_result.t1=time_end1;
time_result.t2=time_end2;
	
   
    