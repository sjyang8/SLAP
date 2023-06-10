function []=call_SLAP()
%the main call funtion for running the whole algorithm
%written by Shujun Yang (yangsj3@sustech.edu.cn; sjyang8-c@my.cityu.edu.hk)
img_name='Indian_pines'; 
num_Pixel=[64]; r=1; per_ratio=[0.07];
par.r=r;
par.lambda=1;
par.gama=20;
par.alpha=0.96;
main_SLAP(img_name,par,num_Pixel,per_ratio,0);
end
