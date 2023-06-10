function [sub_I,size_subimage,position_2D]=Partition_into_subimages_superpixel(I,labels)
% ---------------------------------------------
% Input:
% I      			- the orignal 3D image
% labels 			- the labels for image
%----------------------------------------------
% Output: 
%% position_2D: 	-	a cell num_superpixel*1; store the pixel positions for each superpixel
%% sub_I: 			-	a cell num_superpixel*1; store each superpixel
%% size_subimage:	-	a cell num_superpixel*1; store the size of each superpixel
%---------------------------------------------
%written by Shujun Yang (yangsj3@sustech.edu.cn; sjyang8-c@my.cityu.edu.hk)
%---------------------------------------------
[m,n,b]=size(I);
data_2D=reshape(I,[],b);
max_label=max(unique(labels));
label_2D=reshape(labels,[m*n 1]);
for cnt=1:max_label
    tmp_pos=find(label_2D==cnt);
    tmp_sub_I=data_2D(tmp_pos,:);
    sub_I{cnt}=tmp_sub_I;
    size_subimage{cnt}=size(tmp_sub_I,1);
    position_2D{cnt}=tmp_pos;
end

