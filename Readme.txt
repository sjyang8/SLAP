------------------------------------------------------------------------------------------
	                   Readme for the SLAP Package
	 		       version June 10, 2023
------------------------------------------------------------------------------------------
The package includes the MATLAB code of the SLAP algorithm in the paper "Superpixelwise Low-rank Approximation based Partial Label Learning for Hyperspectral Image Classification" [1].

[1] Shu-Jun Yang, Yu Zhang, Yao Ding, Dan-Feng Hong. Superpixelwise Low rank Approximation based Partial Label Learning for Hyperspectral Image Classification. IEEE Geoscience and Remote Sensing Letters (GRSL), vol 20, pages 1-5, 2023.

1)  Get Started
For SLAP,  you can call the "call_SLAP.m" function to run the algorithm for Indian_pines dataset. 

2)  Details

For SLAP,  the "call_SLAP.m" will automatically create a new folder for saving the detailed results,  i.e., "Indian_pinesSP64SVM_results/lambda1gama20/ratio0.07/r1/". In such a folder, 
for example, the result file "Indian_pinesSP64lambda1gama20alpha0.96per_C0.07.mat" saves the results for 10 runs.  In the following, we also show a detailed description of the 
variables that are stored in the result file.
Variable description:
accuracy_SVM1 	-------- 	OA on the original feature (10 runs)
accuracy_SVM2  	-------- 	OA on the denoising feature by SLAP (10 runs)
Kappa_SVM1     	--------	Kappa on the original feature (10 runs)
Kappa_SVM2    	--------	Kappa on the denoising feature by SLAP (10 runs)
TPR_SVM1         	--------	Accuracy of each class on the original feature (10 runs)
TPR_SVM2  	--------    Accuracy of each class on the denoising feature by SLAP (10 runs)
Predict_SVM1	--------	The prediction on the original feature (10 runs)
Predict_SVM2	--------	The prediction on the denoising feature by SLAP (10 runs)
ave_train_OA  --------	the average OA of the disambiguated training labels 
ave_train_Kappa --------	the average Kappa of the disambiguated training labels 
ave_train_AA --------	the average AA of the disambiguated training labels
res  --------- the average result summary for 10 runs
	 res. ave_OA_SVM1 ------- the average OA for 10 runs on the original feature
	 res. ave_OA_SVM2 ------- the average OA for 10 runs by SLAP
	 res. ave_AA_SVM1 ------- the average AA for 10 runs on the original feature
	 res. ave_AA_SVM2 ------- the average AA for 10 runs by SLAP
	 res. ave_Kappa_SVM1 ------- the average Kappa for 10 runs on the original feature
	 res. ave_Kappa_SVM2 ------- the average Kappa for 10 runs by SLAP
	 res. ave_TPR_SVM1 ------- the average Accuracy of each class for 10 runs on the original feature 
	 res. ave_TPR_SVM2 ------- the average Accuracy of each class for 10 runs by SLAP 
	 res. OA_SVM1_std ------- the average std of OA for 10 runs on the original feature
	 res. OA_SVM2_std ------- the average std of OA for 10 runs by SLAP
	 res. AA_SVM1_std ------- the average std of AA for 10 runs on the original feature
	 res. AA_SVM2_std ------- the average std of AA for 10 runs by SLAP
	 res. Kappa_SVM1_std ------- the average std of Kappa for 10 runs on the original feature
	 res. Kappa_SVM2_std ------- the average std of Kappa for 10 runs by SLAP
	 res. TPR_SVM1_std ------ the average std of Accuracy of each class for 10 runs on the original feature 
	 res. TPR_SVM2_std ------ the average std of Accuracy of each class for 10 runs by SLAP 

Dependencies:
1)Entropy Rate Superpixel Segmentation
2)MATLAB toolboxes on my PC that you may need:
-----------Deep Learning Toolbox
-----------Image Processing Toolbox
-----------Mapping Toolbox
-----------Optimization Toolbox
-----------Statistics and Machine Learning Toolbox
-----------Symbolic Math Toolbox

Acknowledgment
1) Thanks to the paper "SuperPCA: A Superpixelwise PCA Approach for Unsupervised Feature Extraction of Hyperspectral Imagery", we refer to some codes that are saved in the folder "common".
2) Thanks to the paper "Simultaneous spatial and spectral low-rank representation of hyperspectral images for classification", we refer to its classification codes saved in the folder "classification_code."

ATTN: 
- This package is free for academic usage. You can run it at your own risk. 

- This package was developed by Ms. Shu-Jun Yang (yangsj3@sustech.edu.cn; sjyang8-c@my.cityu.edu.hk). For any problem concerning the code, please feel free to contact Ms. Yang.
