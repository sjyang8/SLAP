function [G,D,W_sparse] = build_Lap_graph(X_sub,X_pos,par,sub_cluster_n)
% ---------------------------------------------
%% Input:
%X_sub - d*N
%X_pos - d1*d2
%par.k - k nearest neighbors parameter (default 1)
%par.D1 - the height of the map
%par.D2 - the width of the map
%sub_cluster_n=[n1,n2,n3,...nC]; N=\sum_{i=1}^{C}n_i
%% Output:
% G - N*N
% D - N*N
% W_sparse - N*N
%---------------------------------------------
%written by Shujun Yang (yangsj3@sustech.edu.cn; sjyang8-c@my.cityu.edu.hk)
%---------------------------------------------
[d,N]=size(X_sub);
W_sparse=sparse(N,N);
D=sparse(N,N);
G=sparse(N,N);
tic
[d1,d2]=size(X_pos);
num_pixel=max(d1,d2);
for jth=1:num_pixel 
%% the pos in X (sum(sub_cluster_n(1:ith-1))+1:sum(sub_cluster_n(1:ith)))
	[x,y]=pos1d_to_2d(X_pos(jth),par.D1);
	actual_id1_G=jth;
	%% k nearest neighbors
	x_min=max(1,x-par.k);
	x_max=min(x+par.k,par.D1);
	y_min=max(1,y-par.k);
	y_max=min(y+par.k,par.D2);
	for k1=x_min:x_max
		for k2=y_min:y_max
			[pos_1d]=pos2d_to_1d(k1,k2,par.D1);
			[IDx]=find(X_pos==pos_1d);
			[d1,d2]=size(IDx);
			if min(d1,d2)>0
				actual_id2_G=IDx;
				tmp_vector=(X_sub(:,actual_id1_G)-X_sub(:,actual_id2_G));
				W_sparse(actual_id1_G,actual_id2_G)=exp(-par.sigma*(tmp_vector'*tmp_vector));
			end
		end
	end
end

W_sparse=(W_sparse+W_sparse')/2;
for i=1:N
	 D(i,i)=sum(W_sparse(i,:));
end
G=D-W_sparse;
usedtime=toc
fprintf(1,'the laplacian graph computes using %d seconds\n',usedtime);
end

