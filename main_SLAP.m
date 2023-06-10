function [] = main_SLAP(img_name,par,num_Pixel,per_ratio,DEBUG)
%the main call funtion for 3-step algorithm framework:
% (1) superpixel segmentation and (2) build graph by self-representation (3) label propagation with the similarity graph and SVM classification

%written by Shujun Yang (yangsj3@sustech.edu.cn; sjyang8-c@my.cityu.edu.hk)
addpath(genpath('.\classification_code\'));
addpath('./common/');
addpath(genpath(cd));
addpath('./Entropy Rate Superpixel Segmentation/');
path1='./';

%% prepare for data --read file
R=importdata([img_name '_corrected.mat']);
gt=importdata([img_name '_gt.mat']);
[m,n,d]=size(R);
R=double(R);
par.D1=m; %% the height of the map
par.D2=n;
par.sigma=1.0;
par.k=1;

C=max(gt(:));
save_path=['./train_indexes2_PL/' img_name  '/' 'r' num2str(par.r) '/' num2str(per_ratio) '/'];
if ~exist(save_path,'dir')
	generate_train_index_ratio_pl(par.r,per_ratio,img_name,gt);
end

random_iters=10; %% random 10 times for SVM classifier
gt_ori=gt;
old_para=par;
para.r=par.r;
lambda=par.lambda;
gama  =par.gama;
alpha =par.alpha;
%% step1-- over segmentation based on ERS
%% this part of code could reference the superPCA
data3D=R; 
%% max normalize before segment
data3D = data3D./max(data3D(:));

%% super-pixels segmentation
labels = cubseg(data3D,num_Pixel);
labels=labels+1;

%% cut into multiple sub images according to segment labels
[sub_I,size_subimage,position_2D]=Partition_into_subimages_superpixel(data3D,labels);%% input is maxnormlized feature
%% parepare for data matrix
X=[];
for cur=1:num_Pixel
    X=[X;sub_I{cur}];
    sub_cluster_n(cur)=size(sub_I{cur},1);
end
save_path=['./' img_name 'SP' num2str(num_Pixel) '_SLAP_feature_graph_parfor/' ];
save_path2=['./' img_name 'SP' num2str(num_Pixel) 'SVM_results/' 'lambda' num2str(lambda) 'gama' num2str(gama) '/' 'ratio' num2str(per_ratio) '/' 'r' num2str(par.r) '/'];
if DEBUG==0
	res_file_name1= [img_name 'SP' num2str(num_Pixel) 'lambda' num2str(lambda)  'gama' num2str(gama) '.mat'];
else
	res_file_name1= [img_name 'SP' num2str(num_Pixel) 'lambda' num2str(lambda)  'gama' num2str(gama) '_debug.mat'];
end

if ~exist(save_path,'dir')
    mkdir(save_path);
end

if ~exist(save_path2,'dir')
    mkdir(save_path2);
end

%% step2-- build graph by self-representation
%% parameter setting
maxiter=10^3;
rho=1.1;
maxtau = 10^12;
para.maxiter=maxiter;
para.lambda=lambda;%  sparse error term coffecient
para.gama=gama;
para.rho=rho;
para.maxtau=maxtau;
para.DEBUG=DEBUG;

[m,n,b]=size(data3D);
data_2D=reshape(data3D,[],b);
[N,b]=size(data_2D);
Z_W=sparse(N,N);
X=[];
Es=[];

addpath([path1 save_path]);
if ~exist([path1 save_path res_file_name1])
	parfor cur=1:num_Pixel
		[Ls{cur},Ds{cur},Ws{cur}]=build_Lap_graph(sub_I{cur}',position_2D{cur},par,sub_cluster_n);
		[Z{cur},E{cur},W{cur},J{cur},conv_iter{cur},obj2{cur}] = LRA_SLAP(sub_I{cur}',sub_I{cur}',Ls{cur},para);
	end
	for cur=1:num_Pixel
		Z_W(position_2D{cur},position_2D{cur})=Z{cur};
		X=[X;(sub_I{cur}'*Z{cur})'];
		Es=[Es; E{cur}'];
	end
	
	Z_W=(Z_W+Z_W')/2;
	[tmp_s1,tmp_s2]=size(Z_W);
	for i=1:tmp_s2
		Z_W(:,i)=Z_W(:,i)./norm(Z_W(:,i),2);
	end
	parfor i=1:N;
		Ds_diag(i)=sum(Z_W(i,:));
	end;
	D=diag(Ds_diag);
	G=D-Z_W;
	L_spe_m=zeros(N,b);
	for cur=1:num_Pixel
	   L_spe_m(position_2D{cur},:)=X((sum(sub_cluster_n(1:cur-1))+1:sum(sub_cluster_n(1:cur))),:);
	end
	 save([save_path res_file_name1],'L_spe_m','num_Pixel','X','Z_W','Z','sub_I','position_2D','sub_cluster_n','par','para','-v7.3');
else
	load([path1 save_path res_file_name1]);
end

clearvars X G D Z E W J Es Ls Ds Ws sub_I conv_iter obj2;
if DEBUG==0
	res_file_name2= [img_name 'SP' num2str(num_Pixel) 'lambda' num2str(lambda)  'gama' num2str(gama) 'alpha' num2str(alpha)  'per_C' num2str(per_ratio) '.mat'];		
else
	res_file_name2= [img_name 'SP' num2str(num_Pixel) 'lambda' num2str(lambda)  'gama' num2str(gama) 'alpha' num2str(alpha)  'per_C' num2str(per_ratio) '_DEBUG.mat'];		
end	
%% step 3-- label propagation with the similarity graph and SVM classification
 
accracy_SVM1=[];TPR_SVM1=[];Kappa_SVM1=[];
accracy_SVM2=[];TPR_SVM2=[];Kappa_SVM2=[];
accracy_SVMCK1=[];TPR_SVMCK1=[];Kappa_SVMCK1=[];
accracy_SVMCK2=[];TPR_SVMCK2=[];Kappa_SVMCK2=[];
Predict_SVM1=[];Predict_SVM2=[];Predict_SVMCK1=[];Predict_SVMCK2=[];
if isfield(par,'r')
	para.r=par.r;
else
	para.r=old_para.r;
end

if ~exist([save_path2 res_file_name2])
	for ith_iter=1:10
		Train_Test=load_loc_train_test_ratio_pl(img_name,ith_iter,per_ratio,para);
		 L_spe_m=reshape(L_spe_m,[m*n d]);
		[DataTest,DataTrain,TrainTarget]= trans_data(L_spe_m,Train_Test,C);
		[model]=Unlabeled_LP_only_train(TrainTarget,Z_W, Train_Test.loc_train, alpha);
		[train_accuracy(ith_iter),train_TPR{ith_iter},train_Kappa(ith_iter)]= confusion_matrix_wei(model.disambiguatedLabel_v,Train_Test.CTrain);
		gt=gt_ori;
		gt(Train_Test.loc_train)=model.disambiguatedLabel_v;
		fix_gt{ith_iter}=gt;
		 L_spe_m=reshape(L_spe_m,[m n d]);
	   [Tr_Te{ith_iter},accracy_SVM1(ith_iter),TPR_SVM1(ith_iter,:),Kappa_SVM1(ith_iter),accracy_SVM2(ith_iter),TPR_SVM2(ith_iter,:),Kappa_SVM2(ith_iter),Predict_SVM1(ith_iter,:),Predict_SVM2(ith_iter,:),time_result{ith_iter}] = my_Classification_V2_CK_ratio_single_iter2_pl_fix_train_label_t(R,L_spe_m,gt,ith_iter,img_name,per_ratio,para);
	end    
	ave_train_OA=mean(train_accuracy);
	ave_train_Kappa=mean(train_Kappa);
	ave_train_AA=0;
	for ith=1:random_iters
		ave_train_AA=ave_train_AA+mean(train_TPR{ith});
	end
	ave_train_AA=ave_train_AA/random_iters;

	[res.ave_OA_SVM1 res.OA_SVM1_std]=mean_std(accracy_SVM1);
	[res.ave_OA_SVM2 res.OA_SVM2_std]=mean_std(accracy_SVM2);

	[res.ave_Kappa_SVM1	res.Kappa_SVM1_std]=mean_std(Kappa_SVM1);
	[res.ave_Kappa_SVM2	res.Kappa_SVM2_std]=mean_std(Kappa_SVM2);

	[res.ave_TPR_SVM1 res.TPR_SVM1_std]=mean_stds_1(TPR_SVM1);
	[res.ave_TPR_SVM2 res.TPR_SVM2_std]=mean_stds_1(TPR_SVM2);

	[res.ave_AA_SVM1 res.AA_SVM1_std]= mean_stds_2(TPR_SVM1);
	[res.ave_AA_SVM2 res.AA_SVM2_std]= mean_stds_2(TPR_SVM2);

	
	save([save_path2 res_file_name2],'res','ave_train_OA','ave_train_Kappa','ave_train_AA','accracy_SVM1','TPR_SVM1','Kappa_SVM1','accracy_SVM2','TPR_SVM2','Kappa_SVM2','Predict_SVM1','Predict_SVM2');
	  
	end
end


function [DataTest,DataTrain,GT_matrix_train]= trans_data(data_2D,Train_Test,C)
loc_train=Train_Test.loc_train;
loc_test=Train_Test.loc_test;
CTest=Train_Test.CTest;
CTrain=Train_Test.CTrain;
GT_matrix_v1=Train_Test.GT_matrix_v1;

DataTest = data_2D(loc_test, :);

GT_matrix_train=GT_matrix_v1(loc_train,:); %% each line:1*C (0,1) vector, if ith=1 means contains the ith class 
loc_train_new=[];
CTrain_new=[];
DataTrain_new=[];
DataTrain=data_2D(loc_train,:);
end
function [mean_val,std_val]= mean_std(Values)
	mean_val=mean(Values);
	std_val=std(Values);
end
function [mean_val,std_val]= mean_stds_1(Values)
	mean_val=mean(Values,1);
	std_val=std(Values,1);
end
function [mean_val,std_val]= mean_stds_2(Values)
	mean_val=mean(mean(Values,2));
	std_val=std(mean(Values,2));
end

