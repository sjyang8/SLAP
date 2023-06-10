function [Train_Test]=load_loc_train_test_ratio_pl(img_name,i,ratio,para)
%% load data
%---------------------------------------------
%written by Shujun Yang (yangsj3@sustech.edu.cn; sjyang8-c@my.cityu.edu.hk)
%---------------------------------------------
path=['train_indexes2_PL/' img_name '/' 'r' num2str(para.r) '/' num2str(ratio) '/'];

if strcmp(img_name,'Indian_pines')
%     file_name=['indian_train_test' num2str(i) '_0.1.mat'];
    file_name=['Indian_pines_train_test' num2str(i) '_' num2str(ratio) 'r' num2str(para.r) '.mat'];
    load([path file_name]);
elseif strcmp(img_name,'Salinas')
    file_name=['Salinas_train_test' num2str(i) '_' num2str(ratio) 'r' num2str(para.r)  '.mat'];
    load([path file_name]);
end
    Train_Test.loc_train=loc_train;
    Train_Test.loc_test=loc_test;
    Train_Test.CTest=CTest;
    Train_Test.CTrain=CTrain;
	Train_Test.GT_matrix_v1=GT_matrix_v1;
end

