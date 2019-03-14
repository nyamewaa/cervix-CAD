clc,clear
%%
%normal: 51, %cervicitis: 17, %cond: 2 , %CIN1 : 41 %cin2: 10 % CIN3: 5%INV: 8
labels_biop1=cellstr(Pathologybinary([1:134],:));%physicians22([1:134],13);
% [labels_biop1{1:55}] = deal('negative'); %change
% [labels_biop1{56:134}] = deal('positive'); %change
labels_biop=labels_biop1';
% data=[X_norm;X_cervicitis;X_cond;X_CIN1;X_CIN2;X_CIN3;X_inv];
% data=[X_CIN1;X_CIN2;X_CIN3;X_inv];
% data=la_liga([1:134],:);
data=[la_liga,all_stats];
% [labels_biop{1:50}] = deal('normal');
% [labels_biop{51:92}] = deal('lowgrade');
% [labels_biop{93:102}] = deal('highgrade');%cin2
% [labels_biop{103:107}] = deal('highgrade');%cin3
% [labels_biop{108:115}] = deal('highgrade');%invasive
% [labels_biop{116:132}] = deal('lowgrade');%cervicitis
% [labels_biop{133:134}] = deal('lowgrade');%condiloma
% labels_biop=labels_biop';

% data=[X_norm;X_CIN1;X_CIN2;X_CIN3;X_inv;X_cervicitis;X_cond];
holdoutCVP = cvpartition(labels_biop,'holdout',0.3);
dataG1 = data(grp2idx(labels_biop)==1,:);
dataG2 = data(grp2idx(labels_biop)==2,:);
[h,p,ci,stat] = ttest2(dataG1,dataG2,'Vartype','unequal');
%% show what percentage of features have P-values less than alpha
ecdf(p);
xlabel('P value');
ylabel('CDF value')
title('Percent of features having range of p-values')
%% feature names
names={'a_level_lugol','a_mean_img','a_median_img','a_mode_img','a_var_img','b_level_lugol','b_mean_img',...
    'b_median_img','b_mode_img','b_var_img','blue_level_lugol','blue_mean_img','blue_median_img','blue_mode_img',...
    'blue_var_img','CB_level_lugol','CB_mean_img','CB_median_img','CB_mode_img','CB_var_img','CR_level_lugol','CR_mean_img','CR_median_img',...
    'CR_mode_img','CR_var_img','gray_level_lugol','gray_mean_img','gray_median_img','gray_mode_img','gray_var_img',...
    'green_level_lugol','green_mean_img','green_median_img','green_mode_img','green_var_img','h_level_lugol',...
    'h_mean_img','h_median_img','h_mode_img','h_var_img','l_level_lugol','l_mean_img','l_median_img' ,'l_mode_img',...
    'l_var_img','red_level_lugol','red_mean_img','red_median_img','red_mode_img','red_var_img','s_level_lugol',...
    's_mean_img','s_median_img','s_mode_img','s_var_img','v_level_lugol','v_mean_img','v_median_img','v_mode_img',...
    'v_var_img','Y_level_lugol','Y_mean_img','Y_median_img','Y_mode_img','Y_var_img','lesion_size'};%,'contrast','correlation',...
  %  'energy','homogeneity'};
% names={'contrast','correlation','energy', 'homogeneity'};
names=names';
%% determine optimal number
[lll,featureIdxSortbyP] = sort(p,2); % sort the features
testMCE = zeros(1,66);
resubMCE = zeros(1,66);
%%
nfs =1:1:66;
classf = @(xtrain,ytrain,xtest,ytest) ...
    sum(~strcmp(ytest,predict(fitcsvm(xtrain,ytrain,'Standardize',true,'KernelFunction','linear',...
    'KernelScale','auto'),xtest)));
%%

for i = 1:66
    fs = featureIdxSortbyP(1:nfs(i));
    testMCE(i) = crossval(classf,data(:,fs),labels_biop1,'partition',holdoutCVP)...
        /holdoutCVP.TestSize;
end
%%
plot(nfs, testMCE,'o');
xlabel('Number of Features');
ylabel('MCE');
legend({'MCE'},'location','NW');
title('Simple Filter Feature Selection Method');
%% which of the features?
optimal_ID=featureIdxSortbyP(1:66);
optimal_names=names(optimal_ID);
%% testing redundancy
corr(data(:,featureIdxSortbyP(1)),data(:,featureIdxSortbyP(2)))

%% Sequential features
% divide training set for cross validation
fivefoldCVP = cvpartition(labels_biop1,'kfold',5);
%filter and select features in pre-processing
fs1 = featureIdxSortbyP(1:28);
%apply forward sequential feature selection
fsLocal = sequentialfs(classf,data(:,fs1),labels_biop1,'cv',fivefoldCVP);
%%
%determine optimal number from a MCE
[fsCVfor66,historyCV] = sequentialfs(classf,data(:,fs1),labels_biop1,...
    'cv',fivefoldCVP,'Nf',28);
plot(historyCV.Crit,'o');
xlabel('Number of Features');
ylabel('CV MCE');
title('Forward Sequential Feature Selection with cross-validation');
%% comparing to resubstitution
[fsResubfor66,historyResub] = sequentialfs(classf,data(:,fs1),...
    labels_biop1,'cv','resubstitution','Nf',70);
plot(1:70, historyCV.Crit,'bo',1:70, historyResub.Crit,'r^');
xlabel('Number of Features');
ylabel('MCE');
legend({'5-fold CV MCE' 'Resubstitution MCE'},'location','NE');
    %%
%find the features for the number selected
fsCVfor18 = fs1(historyCV.In(3,:))
%order them
[orderlist,ignore] = find( [historyCV.In(1,:); diff(historyCV.In(1:3,:) )]' );
orderlist_arranged=fs1(orderlist)';%get optimal features in order of selection
optimal_names_seq=names(orderlist_arranged);%get feature names
optimal_p=p(orderlist_arranged);

%% Using SVM

% orderlist_arranged=featureIdxSortbyP(1:66);
%seperating data
i=0;
for i=1:100
 pred=data(:,orderlist_arranged); 
%predTrain=dataTrain(:,[1:20]);
resp=labels_biop1;%grpTrain;
inds= ~strcmp(resp,'Negative');

%using mdlSVM for training
mdlSVM = fitcsvm(pred,inds,'Standardize',true,'KernelFunction','linear',...
    'KernelScale','auto');
% mdlSVM = fitPosterior(mdlSVM);
cvLDA=crossval(mdlSVM,'Kfold',5);%10 fold cross validation
[predicted_label,score_svm] = kfoldPredict(cvLDA);
%[Xsvm,Ysvm,Tsvm,AUCsvm,Opt] = perfcurve(inds,score_svm(:,mdlSVM.ClassNames),'true', 'NBoot',1000,'XVals',[0:0.05:1]);

[Xsvm2,Ysvm2,Tsvm2,AUCsvm2,Opt2] = perfcurve(inds,score_svm(:,mdlSVM.ClassNames),'true');
AUCsvm1(i)=AUCsvm2;
i=i+1;
end
AUCsvm=mean(AUCsvm1);
%save svm results
% save('svm_con_int.mat','Xsvm','Ysvm','Tsvm','AUCsvm','Opt')%with confidence interval
% save('svm.mat','Xsvm2','Ysvm2','Tsvm2','AUCsvm2','Opt2')%without confidence interval
%  save('predicted.mat','predicted_label','score_svm','orderlist_arranged','optimal_names_seq','optimal_p','p')
%  % testing on test data
% [label_test,score_test] = predict(mdlSVM,predTest);
% [Xsvmtest,Ysvmtest,Tsvmtest,AUCsvmtest,Opt_test] = perfcurve(indsTest,score_test(:,mdlSVM.ClassNames),'true','NBoot',1000,'XVals',[0:0.05:1]);
% AUCsvmtest
% 
% %log data
% mdl = fitglm(pred,inds,'Distribution','binomial');
% score_new_log = predict(mdl,predTest);
% [Xlog,Ylog,Tlog,AUClog] = perfcurve(indsTest,score_new_log,'true');
%%
%plot ROC
x=[0:1];
y=x;
 plot(Xsvm2,Ysvm2,'k-','linewidth',2)
 hold on
plot(x,y,'k--')
hold off
legend(['SAUC=',num2str(AUCsvm2)],'Random chance','Location','southeast')
xlabel('1-Specificity')
ylabel('Sensitivity')
title('ROC Curve')
savefig('ROC.fig')
 figure
errorbar(Xsvm,Ysvm(:,1),Ysvm(:,1)-Ysvm(:,2),Ysvm(:,3)-Ysvm(:,1),'k-','linewidth',2);
hold on
plot(x,y,'k--')
hold off
legend(['SAUC=',num2str(AUCsvm)],'Random chance','Location','southeast')
xlabel('1-Specificity')
ylabel('Sensitivity')
title('ROC Curve with confidence intervals')
savefig('ROC_CI.fig')
save('svm_con_int.mat','Xsvm','Ysvm','Tsvm','AUCsvm','Opt')%with confidence interval
save('svm.mat','Xsvm2','Ysvm2','Tsvm2','AUCsvm2','Opt2')%without confidence interval
 save('predicted.mat','predicted_label','score_svm','orderlist_arranged','optimal_names_seq','optimal_p','p')

%%
dirlist = dir('*.tif');
name = {dirlist.name}.';
a= {dirlist.name}.';
a=string(a);
a=string(a);