function [x,y]=pos1d_to_2d(pos,D1)
%% transfer 1d position to 2d position
%---------------------------------------------
%written by Shujun Yang (yangsj3@sustech.edu.cn; sjyang8-c@my.cityu.edu.hk)
%---------------------------------------------
	x=mod(pos,D1);
	y=(pos-x)/D1+1;
end