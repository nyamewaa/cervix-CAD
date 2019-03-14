clc,clear
%%
labels_biop1=cellstr(Pathologybinary1([1:134],:));%([1:134],:));
labels_biop=labels_biop1';

%color_features=la_liga([1:134],[1:65]);
%lesion_size=lesion([1:134],66);
data1=[color_features,all_stats];
data=data1([1:134],:);
%data=ROCcurveslugolaftervia040718S1;%([1:134],:);
holdoutCVP = cvpartition(labels_biop,'holdout',0.2);
[dataG1] = data(grp2idx(labels_biop)==1,:);
[dataG2] = data(grp2idx(labels_biop)==2,:);
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
    'v_var_img','Y_level_lugol','Y_mean_img','Y_median_img','Y_mode_img','Y_var_img','lesion_size','contrast','correlation',...
   'energy','homogeneity'};
% names={'contrast','correlation','energy', 'homogeneity'};,;%,'lesion_size'};,};%
names=names';
%% determine optimal number
[lll,featureIdxSortbyP] = sort(p,2); % sort the features
testMCE = zeros(1,70);
resubMCE = zeros(1,70);
%%
nfs =1:1:69;
classf = @(xtrain,ytrain,xtest,ytest) ...
    (loss(~strcmp(ytest,classify(xtest,xtrain,ytrain,'quadratic'))));

%% Sequential features
% divide training set for cross validation
fivefoldCVP = cvpartition(labels_biop1,'kfold',5);
%filter and select features in pre-processing
fs1 = featureIdxSortbyP(1:69);
%determine optimal number from a MCE
[fsCVfor66,historyCV] = sequentialfs(classf,data(:,fs1),labels_biop1,...
    'cv',fivefoldCVP);
plot(historyCV.Crit,'o');
xlabel('Number of Features');
ylabel('CV MCE');
title('Forward Sequential Feature Selection with cross-validation');
%%  
%find the features for the number selected
fsCVfor18 = fs1(historyCV.In(15,:));
%order them
[orderlist,ignore] = find( [historyCV.In(1,:); diff(historyCV.In(1:15,:) )]' );
orderlist_arranged=fs1(orderlist)';%get optimal features in order of selection
optimal_names_seq=names(orderlist_arranged);%get feature names
optimal_p=p(orderlist_arranged);

%% Using SVM
%orderlist_arranged=[4,9,24,68,67,21];%via
%orderlist_arranged=[9,50,17,16,49,59];
%orderlist_arranged=[60,39];
 pred=data(:,orderlist_arranged); 
%predTrain=dataTrain(:,[1:20]);
resp=labels_biop;%grpTrain;
inds= ~strcmp(resp,'Negative');

%using mdlSVM for training
mdlSVM = fitcsvm(pred,inds,'Standardize',true,'KernelFunction','gaussian',...
    'KernelScale','auto');
%%
 % i=0;
  %for i=1:100
cvLDA=crossval(mdlSVM,'Kfold',5);%10 fold cross validation
[predicted_label,score_svm] = kfoldPredict(cvLDA);
%[Xsvm,Ysvm,Tsvm,AUCsvm,Opt] = perfcurve(inds,score_svm(:,mdlSVM.ClassNames),'true', 'NBoot',1000,'XVals',[0:0.05:1]);
[Xsvm,Ysvm,Tsvm,AUCsvm,Opt] = perfcurve(inds,score_svm(:,mdlSVM.ClassNames),'true');
%AUCsvm1(i)=AUCsvm;
%  i=i+1;
%end
%  AUCsvm2=mean(AUCsvm1);
%% testing on test data
datatest=la_liga([108:134],:);
predTest=datatest(:,orderlist_arranged);
labels_test1=cellstr(Pathologybinary1([108:134],:));
labels_test=labels_test1';
indsTest= ~strcmp(labels_test,'Negative');

 [label_test,score_test] = predict(mdlSVM,predTest);
 [Xsvmtest,Ysvmtest,Tsvmtest,AUCsvmtest,Opt_test] = perfcurve(indsTest,score_test(:,mdlSVM.ClassNames),'true');
 AUCsvmtest

%% save svm results
save('svm.mat','Xsvm','Ysvm','Tsvm','AUCsvm','Opt','predicted_label','score_svm')%training set
 save('svmTest.mat','Xsvmtest','Ysvmtest','Tsvmtest','AUCsvmtest','Opt_test','label_test','score_test')% test set
save('predicted.mat','orderlist_arranged','optimal_names_seq','optimal_p','p')
%%
%plot ROC
x=[0:1];
y=x;
plot(Xsvm,Ysvm,'k-','linewidth',2)
hold on
plot(x,y,'k--')
hold off
legend(['SAUC=',num2str(AUCsvm)],'Random chance','Location','southeast')
xlabel('1-Specificity')
ylabel('Sensitivity')
title('ROC Train Curve')
 %savefig('ROCtrain.fig')
%%
 figure
plot(Xsvmtest,Ysvmtest,'k-','linewidth',2)
hold on
plot(x,y,'k--')
hold off
legend(['SAUC=',num2str(AUCsvmtest)],'Random chance','Location','southeast')
xlabel('1-Specificity')
ylabel('Sensitivity')
title('ROC Test Curve')
%savefig('ROCtest.fig')
%%
dirlist = dir('*.tif');
name = {dirlist.name}.';
a= {dirlist.name}.';
a=string(a);
a=string(a);