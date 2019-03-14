% [labels_biop{1:50}] = deal('normal');
% [labels_biop{51:92}] = deal('lowgrade');
% [labels_biop{93:102}] = deal('highgrade');
% [labels_biop{103:107}] = deal('highgrade');
% [labels_biop{108:115}] = deal('inv');
% labels_biop=labels_biop';
%
% data=[X_norm;X_CIN1;X_CIN2;X_CIN3;X_inv];
% id=[1:134];
% dirlist_neg = dir('*.tif');
% dirlist_pos = dir('*.tif');
% dirlist=[dirlist_neg,dirlist_pos];
% dirlist=[dirlist_neg;dirlist_pos];
%test=id(holdoutCVP.test)'
% dirlist(test);

%first load features
clc,clear
%%
[labels_biop1{1:58}] = deal('negative');
[labels_biop1{59:134}] = deal('positive');
labels_biop=labels_biop1';
data=[phys_neg;phys_pos];

% [labels_biop{1:50}] = deal('normal');
% [labels_biop{51:92}] = deal('lowgrade');
% [labels_biop{93:102}] = deal('highgrade');%cin2
% [labels_biop{103:107}] = deal('highgrade');%cin3
% [labels_biop{108:115}] = deal('highgrade');%invasive
% [labels_biop{116:132}] = deal('lowgrade');%cervicitis
% [labels_biop{133:134}] = deal('lowgrade');%condiloma
% labels_biop=labels_biop';
% 
% data=[X_norm;X_CIN1;X_CIN2;X_CIN3;X_inv;X_cervicitis;X_cond];

holdoutCVP = cvpartition(labels_biop,'holdout',0.2);
dataTrain = data(holdoutCVP.training,:);
grpTrain = labels_biop(holdoutCVP.training);

% dataTrainG1 = dataTrain(grp2idx(grpTrain)==1,:);
% dataTrainG2 = dataTrain(grp2idx(grpTrain)==2,:);
% [h,p,ci,stat] = ttest2(dataTrainG1,dataTrainG2,'Vartype','unequal');
dataG1 = data(grp2idx(labels_biop)==1,:);
dataG2 = data(grp2idx(labels_biop)==2,:);
[h,p,ci,stat] = ttest2(dataG1,dataG2,'Vartype','unequal');
%% show what percentage of features have P-values less than alpha
ecdf(p);
xlabel('P value');
ylabel('CDF value')
title('Percent of features having range of p-values')
%% determine optimal number
[lll,featureIdxSortbyP] = sort(p,2); % sort the features
testMCE = zeros(1,66);
resubMCE = zeros(1,66);
%%
nfs =1:1:66;
classf = @(xtrain,ytrain,xtest,ytest) ...
    sum(~strcmp(ytest,predict(fitcsvm(xtrain,ytrain,'Standardize',true,'KernelFunction','RBF',...
    'KernelScale','auto'),xtest)));
%%

resubCVP = cvpartition(length(labels_biop),'resubstitution')
for i = 1:66
    fs = featureIdxSortbyP(1:nfs(i));
    testMCE(i) = crossval(classf,data(:,fs),labels_biop,'partition',holdoutCVP)...
        /holdoutCVP.TestSize;
    resubMCE(i) = crossval(classf,data(:,fs),labels_biop,'partition',resubCVP)/...
        resubCVP.TestSize;
end
%%
plot(nfs, testMCE,'o',nfs,resubMCE,'r^');
xlabel('Number of Features');
ylabel('MCE');
legend({'MCE on the test set' 'Resubstitution MCE'},'location','NW');
title('Simple Filter Feature Selection Method');
%% which of the features?
optimal_ID=featureIdxSortbyP(1:66);
names={'a_level_lugol','a_mean_img','a_median_img','a_mode_img','a_var_img','b_level_lugol','b_mean_img',...
    'b_median_img','b_mode_img','b_var_img','blue_level_lugol','blue_mean_img','blue_median_img','blue_mode_img',...
    'blue_var_img','CB_level_lugol','CB_mean_img','CB_median_img','CB_mode_img','CB_var_img','CR_level_lugol','CR_mean_img','CR_median_img',...
    'CR_mode_img','CR_var_img','gray_level_lugol','gray_mean_img','gray_median_img','gray_mode_img','gray_var_img',...
    'green_level_lugol','green_mean_img','green_median_img','green_mode_img','green_var_img','h_level_lugol',...
    'h_mean_img','h_median_img','h_mode_img','h_var_img','l_level_lugol','l_mean_img','l_median_img' ,'l_mode_img',...
    'l_var_img','red_level_lugol','red_mean_img','red_median_img','red_mode_img','red_var_img','s_level_lugol',...
    's_mean_img','s_median_img','s_mode_img','s_var_img','v_level_lugol','v_mean_img','v_median_img','v_mode_img',...
    'v_var_img','Y_level_lugol','Y_mean_img','Y_median_img','Y_mode_img','Y_var_img','lesion_size'};

names=names';
optimal_names=names(optimal_ID);
%% testing redundancy
corr(dataTrain(:,featureIdxSortbyP(1)),dataTrain(:,featureIdxSortbyP(2)))
%%
% Pval=p(optimal_ID);
%% Sequential features
% divide training set for cross validation
tenfoldCVP = cvpartition(grpTrain,'kfold',5);
%filter and select features in pre-processing
fs1 = featureIdxSortbyP(1:66);
%apply forward sequential feature selection
fsLocal = sequentialfs(classf,dataTrain(:,fs1),grpTrain,'cv',tenfoldCVP);
%%
%determine optimal number from a MCE
[fsCVfor66,historyCV] = sequentialfs(classf,dataTrain(:,fs1),grpTrain,...
    'cv',tenfoldCVP,'Nf',66);
plot(historyCV.Crit,'o');
xlabel('Number of Features');
ylabel('CV MCE');
title('Forward Sequential Feature Selection with cross-validation');
%%
%find the features for the number selected
fsCVfor18 = fs1(historyCV.In(7,:))
%order them
[orderlist,ignore] = find( [historyCV.In(1,:); diff(historyCV.In(1:7,:) )]' );
orderlist_arranged=fs1(orderlist)';%get optimal features in order of selection
optimal_names_seq=names(orderlist_arranged);%get feature names

%test on test data
testMCECVfor18 = crossval(classf,data(:,fsCVfor18),labels_biop,'partition',...
    holdoutCVP)/holdoutCVP.TestSize
%% comparing to resubstitution
[fsResubfor66,historyResub] = sequentialfs(classf,dataTrain(:,fs1),...
    grpTrain,'cv','resubstitution','Nf',66);
plot(1:66, historyCV.Crit,'bo',1:66, historyResub.Crit,'r^');
xlabel('Number of Features');
ylabel('MCE');
legend({'5-fold CV MCE' 'Resubstitution MCE'},'location','NE');
%% Using SVM

%seperating data
 predTrain=data(:,orderlist); 
%predTrain=dataTrain(:,[1:20]);
respTrain=labels_biop;%grpTrain;
indsTrain = ~strcmp(respTrain,'negative');

% dataTest = data(holdoutCVP.test,:);
% grpTest = labels_biop(holdoutCVP.test);
% predTest=dataTest(:,orderlist_arranged);
% %predTest=dataTest(:,[1:20]);
% respTest=grpTest;
% indsTest=~strcmp(respTest,'negative');

%using mdlSVM for training
mdlSVM = fitcsvm(predTrain,indsTrain,'Standardize',true,'KernelFunction','RBF',...
    'KernelScale','auto');
mdlSVM = fitPosterior(mdlSVM);
cvLDA=crossval(mdlSVM,'Kfold',5);%10 fold cross validation
[predicted_label,score_svm] = kfoldPredict(cvLDA);
[Xsvm,Ysvm,Tsvm,AUCsvm,Opt] = perfcurve(indsTrain,score_svm(:,mdlSVM.ClassNames),'true', 'NBoot',1000,'XVals',[0:0.05:1]);
AUCsvm

% % testing on test data
% [label_test,score_test] = predict(mdlSVM,predTest);
% [Xsvmtest,Ysvmtest,Tsvmtest,AUCsvmtest,Opt_test] = perfcurve(indsTest,score_test(:,mdlSVM.ClassNames),'true','NBoot',1000,'XVals',[0:0.05:1]);
% AUCsvmtest
% 
% %log data
% mdl = fitglm(predTrain,indsTrain,'Distribution','binomial');
% score_new_log = predict(mdl,predTest);
% [Xlog,Ylog,Tlog,AUClog] = perfcurve(indsTest,score_new_log,'true');
%% plots
%load concordance
truelabels_biop=concordance(:,7);
truelabels_con=concordance(:,6);
algorithm=concordance(:,1);
schmitt=concordance(:,2);
peyton=concordance(:,3);
muasher=concordance(:,4);
venegas=concordance(:,5);
%%
%find sensitivity and spec for biop
CP_alg_biop=classperf(truelabels_biop,algorithm,'Positive','Positive','Negative','Negative');
CP_s_biop=classperf(truelabels_biop,schmitt,'Positive','Positive','Negative','Negative');
CP_p_biop=classperf(truelabels_biop,peyton,'Positive','Positive','Negative','Negative');
CP_m_biop=classperf(truelabels_biop,muasher,'Positive','Positive','Negative','Negative');
CP_v_biop=classperf(truelabels_biop,venegas,'Positive','Positive','Negative','Negative');

%find stats for consensus
CP_alg_con=classperf(truelabels_con,algorithm,'Positive','Positive','Negative','Negative');
CP_s_con=classperf(truelabels_con,schmitt,'Positive','Positive','Negative','Negative');
CP_p_con=classperf(truelabels_con,peyton,'Positive','Positive','Negative','Negative');
CP_m_con=classperf(truelabels_con,muasher,'Positive','Positive','Negative','Negative');
CP_v_con=classperf(truelabels_con,venegas,'Positive','Positive','Negative','Negative');
%%
%plot ROC
x=[0:1];
y=x;
% plot(Xsvmtest,Ysvmtest,'k-','linewidth',2)
errorbar(Xsvm,Ysvm(:,1),Ysvm(:,1)-Ysvm(:,2),Ysvm(:,3)-Ysvm(:,1));
hold on
plot(x,y,'k--')
hold off
legend(['SAUC=',num2str(AUCsvm)],'Random chance')
%%
plot((1-CP_s_con.Specificity),CP_s_con.Sensitivity,'bs','MarkerSize',10,'MarkerFaceColor','b')%schmitt overall
plot((1-CP_p_con.Specificity),CP_p_con.Sensitivity,'go','MarkerSize',10,'MarkerFaceColor','g')%peyton overall
plot((1-CP_m_con.Specificity),CP_m_con.Sensitivity,'mp','MarkerSize',10,'MarkerFaceColor','m') %Muasher overall
plot((1-CP_v_con.Specificity),CP_v_con.Sensitivity,'rd','MarkerSize',10,'MarkerFaceColor','r')%venegas overall
legend(['SAUC=',num2str(AUCsvmtest)],['LAUC=',num2str(AUClog)],'Random chance','Physician 1','Physician 2', 'Physician 3','Physician 4')%change
set(gca,'FontSize',18);
xlabel('1-Specificity','FontSize',16); ylabel('Sensitivity','FontSize',16);
title('ROC for normal vs abnormal test data')%change
hold off

%%
%calculate kappa for concensus ground truth
cmat_a=confusionmat(concordance(:,6),concordance(:,1))%alg vs consensus
kappa(cmat_a,0,0.05)
cmat_s=confusionmat(concordance(:,6),concordance(:,2))%phys 1 vs cons
kappa(cmat_s,0,0.05)
cmat_p=confusionmat(concordance(:,6),concordance(:,3))
kappa(cmat_p,0,0.05)
cmat_m=confusionmat(concordance(:,6),concordance(:,4))
kappa(cmat_m,0,0.05)
cmat_v=confusionmat(concordance(:,6),concordance(:,5))
kappa(cmat_v,0,0.05)
cmat_p=confusionmat(concordance(:,6),concordance(:,7))
kappa(cmat_p,0,0.05)


%calculate kappa for biopsy ground truth
cmat_a=confusionmat(concordance(:,7),concordance(:,1))
kappa(cmat_a,0,0.05)
cmat_s=confusionmat(concordance(:,7),concordance(:,2))
kappa(cmat_s,0,0.05)
cmat_p=confusionmat(concordance(:,7),concordance(:,3))
kappa(cmat_p,0,0.05)
cmat_m=confusionmat(concordance(:,7),concordance(:,4))
kappa(cmat_m,0,0.05)
cmat_v=confusionmat(concordance(:,7),concordance(:,5))
kappa(cmat_v,0,0.05)
cmat_p=confusionmat(concordance(:,7),concordance(:,6))
kappa(cmat_p,0,0.05)