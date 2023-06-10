function [Z,E,W,J,conv_iter,obj2] = LRA_SLAP(X,A,Ls,para)
%Solve the low rank model for the proposed SLAP method
%% min_{Z,E} ||Z||_{*}+\lambda ||E||_2,1+\gama Tr(AZLs(AZ)^T)
%% s.t. X=AZ+E, Z>=0
% ---------------------------------------------
%% Input:
% X -d*N
% A -d*M
% Ls -N*N
% para- parameter
%	    para.maxiter	-   maximum number of iterations
%		para.lambda		- 	parameter for l2,1 error term (l2,1 norm)
%		para.gama   	-   parameter for laplacian graph term
%       para.rho 		-	rho>=1, ratio used to increase tau
%		para.tau		- 	stepsize for dual variable updating in ADMM
%		para.maxtau		-	maximum stepsize
%		para.DEBUG		-	0 or 1 
%% output:
%	Z - M*N matrix (M*N: num_samples1*num_samples2)
%   E - d*N matrix (d*N: dimension*num_samples2)
%	W - M*N matrix (M*N: num_samples1*num_samples2)
%	J - M*N matrix (M*N: num_samples1*num_samples2)
%   conv_iter		  -  the running iterations until the algorithm converges
%   obj2 			  -  the objective function value
%---------------------------------------------
%written by Shujun Yang (yangsj3@sustech.edu.cn; sjyang8-c@my.cityu.edu.hk)
%---------------------------------------------
%% initialization
maxiter = para.maxiter;
lambda  = para.lambda;
gama 	= para.gama;
rho   	= para.rho;
maxtau  = para.maxtau;
DEBUG   = para.DEBUG;
tau     = 10^(-4);
tol     = 1e-3;

[d,N]=size(X);
[d,M]=size(A);
Y1=zeros(size(X));
E= zeros(size(X));
Z=zeros(M,N);
W=zeros(M,N);
J=zeros(M,N);
Y2=zeros(M,N);
Y3=zeros(M,N);
obj2=[];
derr1s=[];
derr2s=[];
derr3s=[];
current_iter=1;
tmpA=inv(A'*A+2*eye(M,M));
inv_Ls=inv(full(Ls)+1e-12*eye(size(Ls)));
for iter=1:maxiter
	tic
	%%update W
	W=Do_bksvd(1/tau,Z+Y3/tau);
	%%update Z
	Z_tmp=tmpA*(A'*(X-E+Y1/tau)-(Y2/tau-J)-(Y3/tau-W));
	Z=max(Z_tmp,0);
	%%update E
	E=solve_l1l2(X-A*Z+Y1/tau,lambda/tau);
	%%update J
	tmp_A=2*gama*A'*A;tmp_A=full(tmp_A);
	tmp_B=tau*inv_Ls;tmp_B=full(tmp_B);
	tmp_C=tau*(Z+Y2/tau)*inv_Ls;tmp_C=full(tmp_C);
	J=sylvester(tmp_A,tmp_B,tmp_C);
	%% - update the auxiliary lagrange Variables
    %% updata Y	
	Y1=Y1+tau*(X-A*Z-E);
	Y2=Y2+tau*(Z-J);
	Y3=Y3+tau*(Z-W);

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	derr1=X-A*Z-E;
	derr2=Z-J;
	derr3=Z-W;
	derr1s=[derr1s max(max(abs(derr1)))];
	derr2s=[derr2s max(max(abs(derr2)))];
	derr3s=[derr3s max(max(abs(derr3)))];
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if DEBUG
		obj2(iter)=norm_nuclear(W)+lambda*norm_21(E)+gama*trace(A*J*Ls*J'*A')+...
		tau/2*(norm(X-A*Z-E+Y1/tau,'fro'))^2+tau/2*(norm(Z-J+Y2/tau,'fro'))^2+...
		tau/2*(norm(Z-W+Y3/tau,'fro'))^2;
		if (iter == 1) || (mod(iter, 10) == 0) || ((max(max(abs(derr1))) < tol) && (max(max(abs(derr2)))<tol) && (max(max(abs(derr3)))<tol))
            fprintf(1, 'iter: %d \t err1: %f \t  err2: %f \t err3: %f \t  max(E): %f \t obj: %f \n', ...
                iter,max(max(abs(derr1))),max(max(abs(derr2))),max(max(abs(derr3))),max(E(:)),obj2(iter));
        end
	else
		if (iter == 1) || (mod(iter, 10) == 0) || ((max(max(abs(derr1))) < tol) && (max(max(abs(derr2)))<tol) && (max(max(abs(derr3)))<tol))
            fprintf(1, 'iter: %d \t err1: %f \t  err2: %f \t err3: %f \t  max(E): %f \t \n', ...
                iter,max(max(abs(derr1))),max(max(abs(derr2))),max(max(abs(derr3))),max(E(:)));
        end
	end
	%% updata tau
	tau=min(rho*tau,maxtau);
	if (iter >10 && max(max(abs(derr1)))<tol) && (max(max(abs(derr2)))<tol) && (max(max(abs(derr3)))<tol)
        current_iter=iter;
        break;
    end
	toc
end%% end of for iter =1:maxiter

if current_iter<para.maxiter
    conv_iter=current_iter;
else
    conv_iter=para.maxiter;
end
end %% main function end

function r = So(tau, X)
	% shrinkage operator
	r = sign(X) .* max(abs(X) - tau, 0);
end
function r = Do_bksvd(tau, X)
	% shrinkage operator for singular values
	[U, S, V] = bksvd(X);
	r = U*So(tau, S)*V';
end
function [E] = solve_l1l2(W,lambda)
	n = size(W,2);
	E = W;
	for i=1:n
		E(:,i) = solve_l2(W(:,i),lambda);
	end
end
function [x] = solve_l2(w,lambda)
	% min lambda |x|_2 + |x-w|_2^2
	nw = norm(w);
	if nw>lambda
		x = (nw-lambda)*w/nw;
	else
		x = zeros(length(w),1);
	end
end
