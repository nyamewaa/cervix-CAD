% Using SVM
% orderlist_arranged=featureIdxSortbyP(1:66);
%seperating data
via=ROCcurveslugolaftervia040718AutosavedS1(:,1);
vili=ROCcurveslugolaftervia040718AutosavedS1(:,2);
 pred=[via,vili]; 
%predTrain=dataTrain(:,[1:20]);
% resp=Pathologybinary;%grpTrain;
inds=~strcmp(cellstr(Pathologybinary1),'Negative');

%using mdlSVM for training
mdlSVM = fitcsvm(pred,inds,'Standardize',true,'KernelFunction','linear',...
    'KernelScale','auto');
% mdlSVM = fitPosterior(mdlSVM);
cvLDA=crossval(mdlSVM,'Kfold',5);%10 fold cross validation
[predicted_label,score_svm] = kfoldPredict(cvLDA);
[Xsvm,Ysvm,Tsvm,AUCsvm,Opt] = perfcurve(inds,score_svm(:,mdlSVM.ClassNames),'true');%, 'NBoot',1000,'XVals',[0:0.05:1]);
AUCsvm
%save('svm.mat','Xsvm','Ysvm','Tsvm','AUCsvm','Opt','predicted_label','score_svm')%training set
% save('svmTest.mat','Xsvmtest','Ysvmtest','Tsvmtest','AUCsvmtest','Opt_test','label_test','score_test')% test set

%%
%plot ROC
x=[0:1];
y=x;
 plot(Xsvm,Ysvm,'k-','linewidth',2)
 hold on
plot(x,y,'k--')
hold off
legend(['SAUC=',num2str(AUCsvm(1))],'Random chance','Location','southeast')
xlabel('1-Specificity')
ylabel('Sensitivity')
title('ROC Curve')
savefig('ROCtrain.fig')