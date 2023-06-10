function [sum_res]=norm_21(E)
[m,n]=size(E);
sum_res=0;
for j=1:n
	sum_res=sum_res+norm(E(:,j),2);
end
end