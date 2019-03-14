clc,clear

%% testing on test data
datatest=[la_liga,all_stats];
orderlist_arranged=[9,50,17,16,49,59];
predTest=datatest(:,orderlist_arranged);
labels_test1=cellstr(Pathologybinary);%([108:134],:));
labels_test=labels_test1';
indsTest= ~strcmp(labels_test,'Negative');

 [predlabel_test,score_test] = predict(mdlSVM,predTest);
 [Xsvmtest,Ysvmtest,Tsvmtest,AUCsvmtest,Opt_test] = perfcurve(indsTest,score_test(:,mdlSVM.ClassNames),'true');
 AUCsvmtest

%% save svm results
%save('svm.mat','Xsvm','Ysvm','Tsvm','AUCsvm','Opt','predicted_label','score_svm')%training set
 save('svmTest.mat','Xsvmtest','Ysvmtest','Tsvmtest','AUCsvmtest','Opt_test','predlabel_test','score_test')% test set
%save('predicted.mat','orderlist_arranged','optimal_names_seq','optimal_p','p')

%%
 figure
 x=[0:1];
y=x;
plot(Xsvmtest,Ysvmtest,'k-','linewidth',2)
hold on
plot(x,y,'k--')
hold off
legend(['SAUC=',num2str(AUCsvmtest)],'Random chance','Location','southeast')
xlabel('1-Specificity')
ylabel('Sensitivity')
title('ROC Test Curve')
savefig('ROCtest.fig')
%%
dirlist = dir('*.tif');
name = {dirlist.name}.';
a= {dirlist.name}.';
a=string(a);
a=string(a);