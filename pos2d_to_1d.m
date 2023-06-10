function [pos_1d]=pos2d_to_1d(x,y,D1)
%% transfer 2d position to 1d position
%---------------------------------------------
%written by Shujun Yang (yangsj3@sustech.edu.cn; sjyang8-c@my.cityu.edu.hk)
%---------------------------------------------
	pos_1d=(y-1)*D1+x;
end