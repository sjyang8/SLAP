function []=call_SLAP()
%the main call funtion for running the whole algorithm
%written by Shujun Yang (yangsj3@sustech.edu.cn; sjyang8-c@my.cityu.edu.hk)
img_name='Indian_pines'; % data set name
num_Pixel=[64]; % number of superpixels
r=1; % set the value of the parameter r
per_ratio=[0.07]; % The training percentage per class equals 7%
par.r=r; % parameter of r
par.lambda=1; % parameter of \lambda
par.gama=20;  % parameter of \gama
par.alpha=0.96;  % parameter of \alpha
main_SLAP(img_name,par,num_Pixel,per_ratio,0); % call the main function (here 0 means without computing obj)
end
