function [Train_Test]=load_loc_train_test_ratio_fix_train_label(img_name,i,ratio,para,GT_map)
%% load data
%---------------------------------------------
%written by Shujun Yang (yangsj3@sustech.edu.cn; sjyang8-c@my.cityu.edu.hk)
%---------------------------------------------
path=['train_indexes2_PL/' img_name '/' 'r' num2str(para.r)  '/' num2str(ratio) '/'];
if strcmp(img_name,'Indian_pines')
    file_name=['Indian_pines_train_test' num2str(i) '_' num2str(ratio) 'r' num2str(para.r) '.mat'];
    load([path file_name]);
elseif strcmp(img_name,'Salinas')
    file_name=['Salinas_train_test' num2str(i) '_' num2str(ratio) 'r' num2str(para.r) '.mat'];
    load([path file_name]);
end
    Train_Test.loc_test=loc_test;
	loc_train_new=[];
	CTrain_new=[];
	DataTrain_new=[];
    C=max(unique(GT_map));
	gt_train=GT_map(loc_train);
	for i=1:C
	  tr_index=find(gt_train==i);
	  loc_train_new=[loc_train_new;loc_train(tr_index)];
	  CTrain_new=[CTrain_new length(tr_index)];
	end
     Train_Test.CTest=CTest;
	 Train_Test.loc_train=loc_train_new;
	 Train_Test.CTrain=CTrain_new;
 end

