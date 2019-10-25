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
[labels_biop{1:70}] = deal('negative');
[labels_biop{71:134}] = deal('positive');
labels_biop=labels_biop';
% data=[X_colponeg;X_colpopos];

% [labels_biop1{1:51}] = deal('normal');
% [labels_biop1{52:92}] = deal('lowgrade');%CIN1
% [labels_biop1{93:102}] = deal('highgrade');%cin2
% [labels_biop1{103:107}] = deal('highgrade');%cin3
% [labels_biop1{108:115}] = deal('highgrade');%invasive
%  [labels_biop1{116:132}] = deal('lowgrade');%cervicitis
% [labels_biop1{133:134}] = deal('lowgrade');%condiloma
% labels_biop=labels_biop1';
%%
data=[X_norm;X_CIN1;X_CIN2;X_CIN3;X_inv;X_cervicitis;X_cond];
lowgrade=[X_CIN1;X_cervicitis;X_cond];
highgrade=[X_CIN2;X_CIN3];%
invasive=[X_inv];

holdoutCVP = cvpartition(labels_biop,'holdout',0.3);
dataTrain = data;%(holdoutCVP.training,:);
grpTrain = labels_biop(holdoutCVP.training);

dataTrainG1 = dataTrain(grp2idx(grpTrain)==1,:);
dataTrainG2 = dataTrain(grp2idx(grpTrain)==2,:);
[h,p,ci,stat] = ttest2(dataTrainG1,dataTrainG2,'Vartype','unequal');

%% show what percentage of features have P-values less than alpha
ecdf(p);
xlabel('P value');
ylabel('CDF value')
title('Percent of features having range of p-values')
%% determine optimal number
[xxx,featureIdxSortbyP] = sort(p,2); % sort the features
testMCE = zeros(1,66);
resubMCE = zeros(1,66);
nfs =1:66;
t = templateSVM('Standardize',1);
classf = @(xtrain,ytrain,xtest,ytest) ...
    sum(~strcmp(ytest,predict(fitcecoc(xtrain,ytrain,'Learners',t,'FitPosterior',1,......
    'ClassNames',{'normal','lowgrade','highgrade'},...
    'Verbose',2),xtest)));
%%
resubCVP = cvpartition(length(labels_biop),'resubstitution')
for i = 1:66
    fs = featureIdxSortbyP(1:nfs(i));
    testMCE(i) = crossval(classf,data(:,fs),labels_biop,'partition',holdoutCVP)...
        /holdoutCVP.TestSize;
    resubMCE(i) = crossval(classf,data(:,fs),labels_biop,'partition',resubCVP)/...
        resubCVP.TestSize;
end
plot(nfs, testMCE,'o',nfs,resubMCE,'r^');
xlabel('Number of Features');
ylabel('MCE');
legend({'MCE on the test set' 'Resubstitution MCE'},'location','NW');
title('Simple Filter Feature Selection Method');
%%
plot(nfs, testMCE,'o',nfs,resubMCE,'r^');
xlabel('Number of Features');
ylabel('MCE');
legend({'MCE on the test set' 'Resubstitution MCE'},'location','NW');
title('Simple Filter Feature Selection Method');
%% which of the features?
optimal_ID=featureIdxSortbyP(1:4)
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
tenfoldCVP = cvpartition(grpTrain,'kfold',5)
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
fsCVfor5 = fs1(historyCV.In(11,:));
%order them
[orderlist,ignore] = find( [historyCV.In(1,:); diff(historyCV.In(1:11,:) )]' );
orderlist_arranged=fs1(orderlist)';%get optimal features in order of selection
optimal_names_seq=names(orderlist_arranged);%get feature names

%test on test data
testMCECVfor5 = crossval(classf,data(:,fsCVfor5),labels_biop,'partition',...
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
predTrain=data(:,orderlist_arranged);%[20,65,30]); 
respTrain=labels_biop;
% predTrain=dataTrain(:,orderlist_arranged); 
% respTrain=grpTrain;

% dataTest = data(holdoutCVP.test,:);
% grpTest = labels_biop(holdoutCVP.test);
% predTest=dataTest(:,orderlist_arranged);
% respTest=grpTest;

%using mdlSVM for training
t = templateSVM('Standardize',1); 
Mdl = fitcecoc(predTrain,respTrain,'Learners',t,'FitPosterior',1,......
    'ClassNames',{'normal','lowgrade','highgrade'},...
    'Verbose',2);
CVMdl = crossval(Mdl,'leaveout','on');
oosLoss = kfoldLoss(CVMdl)
[new_lab,score] = kfoldPredict(CVMdl);
[Xsvm,Ysvm,Tsvm,AUCsvm,Opt] = perfcurve(respTrain,score(:,1),'normal');
[Xsvm2,Ysvm2,Tsvm2,AUCsvm2,Opt2] = perfcurve(respTrain,score(:,2),'lowgrade');
 [Xsvm3,Ysvm3,Tsvm3,AUCsvm3,Opt3] = perfcurve(respTrain,score(:,3),'highgrade');
%[Xsvm4,Ysvm4,Tsvm4,AUCsvm4,Opt3] = perfcurve(respTrain,score(:,3),'invasive');
AUCsvm
AUCsvm2
AUCsvm3
% AUCsvm4
%%
%test data
[label_test,score_test] = predict(Mdl,predTest);
[Xsvmtest,Ysvmtest,Tsvmtest,AUCsvmtest,Opttest] = perfcurve(respTrain,score(:,1),'normal');
[Xsvmtest2,Ysvmtest2,Tsvmtest2,AUCsvmtest2,Opttest2] = perfcurve(respTrain,score(:,2),'lowgrade');
[Xsvmtest3,Ysvmtest3,Tsvmtest3,AUCsvmtest3,Opttest3] = perfcurve(respTrain,score(:,3),'highgrade');
[Xsvmtest4,Ysvmtest4,Tsvmtest4,AUCsvmtest4,Opttest4] = perfcurve(respTrain,score(:,4),'invasive');
AUCsvmtest
AUCsvmtest2
AUCsvmtest3
AUCsvmtest4
% save('Multiclass_mdl','Mdl'
% testing on test data
%%
% id=[1:134];
% dirlist_neg = dir('*.tif');
% dirlist_pos = dir('*.tif');
% dirlist=[dirlist_neg,dirlist_pos];
% dirlist=[dirlist_neg;dirlist_pos];
%test=id(holdoutCVP.test)'
% dirlist(test);
% [Xsvmtest,Ysvmtest,Tsvmtest,AUCsvmtest,Opt_test] = perfcurve(indsTest,score_test(:,mdlSVM.ClassNames),'true');
% AUCsvmtest
%%

%%
% plot(0.2381,0.8667,'bs','MarkerSize',10,'MarkerFaceColor','b')%normal 
% plot(0.4783,0.1923,'go','MarkerSize',10,'MarkerFaceColor','g')%low
% plot(0.3171,0.6154,'mp','MarkerSize',10,'MarkerFaceColor','m') %high
% 
% legend(['AUC Normal=',num2str(AUCsvm)],['AUC Low grade=',num2str(AUCsvm2)],['AUC High grade=',num2str(AUCsvm3)],'Random chance','Physician Normal', 'Physician Low grade','Physician High grade')%change
% set(gca,'FontSize',18);
% xlabel('1-Specificity','FontSize',16); ylabel('Sensitivity','FontSize',16);
% title('Normal(n=62, Low grade(n=47), high grade(n=25) ')%change
% hold off
% hold off
%% plots
%load concordance
truelabels_biop=multiclassresults(:,5);
algorithm=multiclassresults(:,3);
schmitt=multiclassresults(:,4);

%%
%find sensitivity and spec for biop
%normal
CP_alg_norm=classperf(truelabels_biop,algorithm,'Positive','Negative','Negative',{'Low grade' ,'High grade'});%for normal
CP_s_norm=classperf(truelabels_biop,schmitt,'Positive','Negative','Negative',{'Low grade' ,'High grade'});
%low grade
CP_alg_low=classperf(truelabels_biop,algorithm,'Positive','Low grade','Negative',{'Negative' ,'High grade'});%for normal
CP_s_low=classperf(truelabels_biop,schmitt,'Positive','Low grade','Negative',{'Negative' ,'High grade'})
%high grade
CP_alg_high=classperf(truelabels_biop,algorithm,'Positive','High grade','Negative',{'Negative' ,'Low grade'});%for normal
CP_s_high=classperf(truelabels_biop,schmitt,'Positive','High grade','Negative',{'Negative' ,'Low grade'})

%%
%plot ROC
plot(Xsvm,Ysvm,'b',Xsvm2,Ysvm2,'g',Xsvm3,Ysvm3,'m','linewidth',2)
hold on
x=[0:1];
y=x;
plot(x,y,'k--')
hold off
legend(['normal AUC=',num2str(AUCsvm)],['lowgrade AUC=',num2str(AUCsvm2)],['highgrade AUC=',num2str(AUCsvm3)],'Random chance')
%%
plot((1-CP_s_norm.Specificity),CP_s_norm.Sensitivity,'bs','MarkerSize',10,'MarkerFaceColor','b')%schmitt overall
plot((1-CP_s_low.Specificity),CP_s_low.Sensitivity,'go','MarkerSize',10,'MarkerFaceColor','g')%peyton overall
plot((1-CP_s_high.Specificity),CP_s_high.Sensitivity,'mp','MarkerSize',10,'MarkerFaceColor','m') %Muasher overall
legend(['AUC Normal=',num2str(AUCsvmtest)],['AUC Low grade=',num2str(AUCsvmtest2)],['AUC High grade=',num2str(AUCsvmtest3)],'Random chance','Physician Normal', 'Physician Low grade','Physician High grade')%change
set(gca,'FontSize',18);
xlabel('1-Specificity','FontSize',16); ylabel('Sensitivity','FontSize',16);
title('Cervical Pre-cancer Grading')%change

%%
%calculate kappa for concensus ground truth
cmat_a=confusionmat(multiclassresults(:,3),multiclassresults(:,5))%alg and biopsy
kappa(cmat_a,0,0.05)
cmat_s=confusionmat(multiclassresults(:,4),multiclassresults(:,5))%schmitt and biopsy
kappa(cmat_s,0,0.05)
cmat_p=confusionmat(multiclassresults(:,3),multiclassresults(:,4))%algor schmiit
kappa(cmat_p,0,0.05)
%%

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
%%
%% Boxlot
figure;
x1=double(X_norm(:,20));
x2=double(low_grade(:,20));
x3=double(high_grade(:,20));
group = [repmat({'First'}, 51, 1); repmat({'Second'}, 60, 1); repmat({'Third'}, 23, 1)];
boxplot([x1; x2; x3],group,'labels',{'Normal','Low-grade', 'High-grade'})
title(' b var for cervical cancer grades')
ylabel('b var')
%%
[h,p]=ttest2(x3,x1)
%%
boxplot([x1;x2;x3],'notch','on','labels',{'Normal'})
hold on 
boxplot([x2],'notch','on','labels',{'Abormal'})
title('Normal vs Abnormal Data for Blue mode (n=26, ab=59)')
ylabel('Green Channel Threshold')
