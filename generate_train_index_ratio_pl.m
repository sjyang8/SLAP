function [] = generate_train_index_ratio_pl(r,per_ratio,img_name,GT_map)
%% generate train and test data
%---------------------------------------------
%written by Shujun Yang (yangsj3@sustech.edu.cn; sjyang8-c@my.cityu.edu.hk)
%---------------------------------------------
C=max(unique(GT_map));
C_total=[];
for class=1:C
    no_class(class)=length(find(GT_map==class));
    C_total=[C_total  no_class(class)];
end
CTrain=ceil(C_total*per_ratio);
random_iter=10;
save_path=['./train_indexes2_PL/' img_name  '/' 'r' num2str(r) '/' num2str(per_ratio) '/'];
if ~exist(save_path,'dir')
	mkdir(save_path);
end
[GT_matrix]=transfer_gtmap_gtmatrix(GT_map); %% each instance has a long vector with 0,1 value to indicate the class label
[d1,d2]=size(GT_map);
C=max(unique(GT_map));
GT_matrix_v=reshape(GT_matrix,d1*d2, C);
p=1;
for i=1:random_iter
	save_file_name=[save_path '/' img_name '_train_test' num2str(i) '_' num2str(per_ratio) 'r' num2str(r) '.mat']
    [loc_train, loc_test, CTest] = Generating_training_testing(GT_map,CTrain);
	GT_matrix_v1=GT_matrix_v;%% each time initialize the GT_matrix_v1
	[n_train,dim]=size(loc_train);
	rmp_vector=randperm(n_train);
	loc_train_add=loc_train(rmp_vector(1:ceil(p*n_train)));
	%% loc_train_add add the false positive label with r
	[n_train_fp,dim]=size(loc_train_add);
	for j=1:n_train_fp
		tmp_gnd=GT_map(loc_train_add(j));
		tmp_classes=[1:C];
		tmp_rest_classes=tmp_classes(tmp_classes~=tmp_gnd);
		rand_tmp_rest_classes=tmp_rest_classes(randperm(C-1));
		for k=1:r
			GT_matrix_v1(loc_train_add(j),rand_tmp_rest_classes(k))=1;%% actual training label with partial label
		end
	end
	save(save_file_name,'CTrain','loc_train', 'loc_test', 'CTest','GT_matrix_v1','loc_train_add','GT_matrix_v','GT_matrix');
end
end
function [GT_matrix]=transfer_gtmap_gtmatrix(GT_map)
%% each instance has a long class vector with 0,1 values
	[d1,d2]=size(GT_map);
	C=max(unique(GT_map));
	GT_matrix=zeros(d1,d2,C);
	for i1=1:d1
		for i2=1:d2
			if(GT_map(i1,i2)~=0)
				GT_matrix(i1,i2,GT_map(i1,i2))=1;
			end
		end
	end

end

