function [model]=Unlabeled_LP_only_train(partialTarget,Z_W, loc_train_new, alpha)
% ---------------------------------------------
%% Input:
%partialTarget  - a*label_num matrix (num of train data* num of labels) candidate labels of the train data
%Z_W 			- N*N matrix (total num of all data* total num of all data)
%loc_train_new  - a*1 (num of train data*1) --position of train data
%alpha -the parameter for label propagation
%% output:
% model--the output of model
%		model.disambiguatedLabel_v	- the disambiguated Label of training data

%---------------------------------------------
%written by Shujun Yang (yangsj3@sustech.edu.cn; sjyang8-c@my.cityu.edu.hk)
%---------------------------------------------
[a, label_num] = size(partialTarget);

Fp = partialTarget;
Fp = Fp ./ repmat(sum(Fp, 2), 1, label_num);

Waa = sparse(a, a);
Waa= Z_W(loc_train_new,loc_train_new);


%% the following code refers from the code of the following paper 
% [1]Q.-W. Wang, Y.-F. Li, Z.-H. Zhou. Partial Label Learning with Unlabeled Data. In: Proceedings of the 28th International Joint Conference on Artificial Intelligence (IJCAI'19), Macau, China. 2019.
 %%%%%%%%% start of the referred part 
sumWaa = sum(Waa, 2);
sumWaa(sumWaa == 0) = 1;

J = Waa ./ repmat(sumWaa, 1, a);
J = sparse(J);


maxIter = 100;
Fp_ = Fp;
for iter = 1:maxIter
    tmp = Fp;
    
    Fp = alpha * J * Fp + (1 - alpha) * Fp_;
    Fp = Fp .* partialTarget;
    Fp = Fp ./ repmat(sum(Fp,2), 1, label_num);
   
    diff = norm(full(Fp) - full(tmp));
    if abs(diff) < 0.0001
        break
    end
end
fprintf('label propagation iteration: %d\n', iter);

labelSum = sum(Fp_);
predSum = sum(Fp);
poster = labelSum ./ predSum;
Fp = Fp .* repmat(poster, a, 1);

disambiguatedLabel = zeros(a, label_num);
disambiguatedLabel_v=zeros(a,1);
for i = 1:a
    [~, idx] = max(Fp(i,:));
    disambiguatedLabel(i,idx) = 1;
	disambiguatedLabel_v(i)=idx;
end

model.disambiguatedLabel = disambiguatedLabel;
model.disambiguatedLabel_v = disambiguatedLabel_v;
 %%%%%%%%% end of the referred part 
