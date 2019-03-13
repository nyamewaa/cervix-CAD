
% clc,clear
%% use for unsorted daqta
labels_biop=cellstr(BiopsyBin);%read in excel sheet via0225182.xlsx
%select sheet which say VIA features gabor. Select pathology binary column and read in as a
%column vector
labels_biop1=labels_biop';
data=all_feats;% [all_stats,color_features];%([1:134],:); %viaaftervili([1:98],:);
%% Use for partitioned data
[labels_biop1{1:21}] = deal('negative');
[labels_biop1{22:52}] = deal('positive');
%[labels_biop1{19:49}] = deal('positive');
labels_biop=labels_biop1';

data=[neg;pos];
%%
holdoutCVP = cvpartition(labels_biop1,'holdout',0.3);
dataG1 = data(grp2idx(labels_biop1)==1,:);
dataG2 = data(grp2idx(labels_biop1)==2,:);
[h,p,ci,stat] = ttest2(dataG1,dataG2,'Vartype','equal');
%% show what percentage of features have P-values less than alpha
ecdf(p);
xlabel('P value');
ylabel('CDF value')
title('Percent of features having range of p-values')
%% feature names
names={'contrast','correlation','energy','homogeneity','viaa_level_lugol','viaa_mean_img','viaa_median_img','viaa_mode_img','viaa_var_img','viab_level_lugol','viab_mean_img',...
    'viab_median_img','viab_mode_img','viab_var_img','viablue_level_lugol','viablue_mean_img','viablue_median_img','viablue_mode_img',...
    'viablue_var_img','viaCB_level_lugol','viaCB_mean_img','viaCB_median_img','viaCB_mode_img','viaCB_var_img','viaCR_level_lugol','viaCR_mean_img','viaCR_median_img',...
    'viaCR_mode_img','viaCR_var_img','viagray_level_lugol','viagray_mean_img','viagray_median_img','viagray_mode_img','viagray_var_img',...
    'viagreen_level_lugol','viagreen_mean_img','viagreen_median_img','viagreen_mode_img','viagreen_var_img','viah_level_lugol',...
    'viah_mean_img','viah_median_img','viah_mode_img','viah_var_img','vial_level_lugol','vial_mean_img','vial_median_img' ,'vial_mode_img',...
    'vial_var_img','viared_level_lugol','viared_mean_img','viared_median_img','viared_mode_img','viared_var_img','vias_level_lugol',...
    'vias_mean_img','vias_median_img','vias_mode_img','vias_var_img','viav_level_lugol','viav_mean_img','viav_median_img','viav_mode_img',...
    'viav_var_img','viaY_level_lugol','viaY_mean_img','viaY_median_img','viaY_mode_img','viaY_var_img'};%...
    %'viacontrast','viacorrelation','viaenergy','viahomogeneity'};
%names_t={'viacontrast','viacorrelation','viaenergy','viahomogeneity'};%,'viagab_mean','viagab_median','viagab_var'}
%names=[names_c,names_t];
names=names';
%% determine optimal number
[pval,featureIdxSortbyP] = sort(p,2); % sort the features
testMCE = zeros(1,69);
resubMCE = zeros(1,69);
%%
nfs =1:1:69;
classf = @(xtrain,ytrain,xtest,ytest) ...
    sum(~strcmp(ytest,predict(fitcsvm(xtrain,ytrain,'Standardize',true,'KernelFunction','Gaussian',...
    'KernelScale','auto'),xtest)));
%%

for i = 1:69
    fs = featureIdxSortbyP(1:nfs(i));
    testMCE(i) = crossval(classf,data(:,fs),labels_biop,'partition',holdoutCVP)...
        /holdoutCVP.TestSize;
end
%%
plot(nfs, testMCE,'o');
xlabel('Number of Features');
ylabel('MCE');
legend({'MCE'},'location','NW');
title('Simple Filter Feature Selection Method');
%% which of the features?
optimal_ID=featureIdxSortbyP(1:69);
optimal_names=names(optimal_ID);
%% testing redundancy
corr(data(:,featureIdxSortbyP(1)),data(:,featureIdxSortbyP(2)))

%% Sequential features
% divide training set for cross validation
fivefoldCVP = cvpartition(labels_biop1,'kfold',5);
%filter and select features in pre-processing
fs1 = featureIdxSortbyP(1:69);
%apply forward sequential feature selection
% fsLocal = sequentialfs(classf,data(:,fs1),labels_biop,'cv',fivefoldCVP);
%%
%determine optimal number from a MCE
[fsCVfor66,historyCV] = sequentialfs(classf,data(:,fs1),labels_biop,...
    'cv',fivefoldCVP,'Nf',69);
plot(historyCV.Crit,'o');
xlabel('Number of Features');
ylabel('CV MCE');
title('Forward Sequential Feature Selection with cross-validation');
    

%%
%find the features for the number selected
fsCVfor18 = fs1(historyCV.In(3,:));
%order them
[orderlist,ignore] = find( [historyCV.In(1,:); diff(historyCV.In(1:3,:) )]' );
orderlist_arranged=fs1(orderlist)';%get optimal features in order of selection
optimal_names_seq=names(orderlist_arranged);%get feature names
optimal_p=p(orderlist_arranged);

%% Using SVM
% orderlist_arranged=featureIdxSortbyP(1:66);
%seperating data
%orderlist_arranged=[11,16,31,3,2,28];
 pred=data(:,orderlist_arranged); 
%predTrain=dataTrain(:,[1:20]);
resp=labels_biop1;%grpTrain;
inds= ~strcmp(resp,'negative');
%%
% for i=1:100
%using mdlSVM for training
mdlSVM = fitcsvm(pred,inds,'Standardize',true,'KernelFunction','Gaussian',...
    'KernelScale','auto');
% mdlSVM = fitPosterior(mdlSVM);
cvLDA=crossval(mdlSVM,'Kfold',5);%10 fold cross validation
[predicted_label,score_svm] = kfoldPredict(cvLDA);
[Xsvm,Ysvm,Tsvm,AUCsvm,Opt] = perfcurve(inds,score_svm(:,mdlSVM.ClassNames),'true');%'NBoot',1000,'XVals',[0:0.05:1]);
AUCsvm
%  i=i+1;
 %end
%%
%%KNN
mdlknn = fitcknn(pred,inds,'Standardize',true,'NumNeighbors', 20,'Distance','euclidean','DistanceWeight','squaredinverse');
cvLDA1=crossval(mdlknn,'Kfold',5);%10 fold cross validation
[predicted_labelknn,score_knn] = kfoldPredict(cvLDA1);
[Xknn,Yknn,Tknn,AUCknn,Optknn] = perfcurve(inds,score_knn(:,mdlknn.ClassNames),'true','xvals','all');%, 'NBoot',1000,'XVals',[0:0.05:1]);
AUCknn
%%
%log data
mdl = fitglm(pred,inds,'Distribution','binomial');
score_log = mdl.Fitted.Probability;
[Xlog,Ylog,Tlog,AUClog] = perfcurve(inds,score_log,'true');
AUClog
%%

%save svm results
save('svm1.mat','Xsvm','Ysvm','Tsvm','AUCsvm','Opt','predicted_label','score_svm')%with confidence interval
% save('knn.mat','Xknn','Yknn','Tknn','AUCknn','Optknn','predicted_labelknn','score_knn')%without confidence interval
% save('log.mat','Xlog','Ylog','Tlog','AUClog','score_log')%with confidence interval

save('selected_features.mat','orderlist_arranged','optimal_names_seq','optimal_p','p')
% % testing on test data
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
 plot(Xsvm,Ysvm,'k-','linewidth',5)
hold on
% plot(Xknn,Yknn,'b-','linewidth',1)
% plot(Xlog,Ylog,'g-','linewidth',1)
 plot(x,y,'k--')
 hold off
legend(['SVM AUC=',num2str(AUCsvm)],'Random chance','Location','southeast')
xlabel('1-Specificity','fontsize', 18,'fontweight','bold')
ylabel('Sensitivity','fontsize', 18,'fontweight','bold')
title('VIA for clear cut images', 'fontsize', 18,'fontweight','bold')
%%
savefig('ROC.fig')
%  figure
% errorbar(Xsvm,Ysvm(:,1),Ysvm(:,1)-Ysvm(:,2),Ysvm(:,3)-Ysvm(:,1),'k-','linewidth',2);
% hold on
% plot(x,y,'k--')
% hold off
% legend(['SAUC=',num2str(AUCsvm)],'Random chance','Location','southeast')
% xlabel('1-Specificity')
% ylabel('Sensitivity')
% title('ROC Curve with confidence intervals')
% savefig('ROC_CI.fig')
%%
% dirlist = dir('*.tif');
% name = {dirlist.name}.';
% a= {dirlist.name}.';
% a=string(a);
% a=string(a);