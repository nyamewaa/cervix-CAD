combinedMdl=load('svmcombineMDL.mat');
combinedMdl=combinedMdl.mdlSVM;
via=load('via_predicted.mat');
vili=load('vili_predicted.mat');
via_score=via(:,2);
vili_score=vili(:,2);
feat=[via_score,vili_score];

[label,score]=predict(combinedMdl,feat);
parallel_predict=[label,score];
save('parallel_predict.mat','parallel_predict')