clc,clear
%%
resp=cellstr(Pathologybinary1);%labels_biop1;%grpTrain;
inds=~strcmp(resp,'Negative');
normal_low=inds([1:134]);
inds_VILI=inds([1:134]);
% VILI1=VILIscores;

% VIA1=VILI([1:134]);  %ROCcurves(:,1);
% VIA2=vilitop6;
% VILI1=VILI([1:134]); %ROCcurves(:,2);
 combinedpar=combinedold([1:134]);%ROCcurves(:,3);
%combinedser=combined([1:134]);%ROCcurves(:,3);
%%
[Xsvm,Ysvm,Tsvm,AUCsvm,Opt] = perfcurve(inds_VILI,VIA,'true');
%[Xsvm2,Ysvm2,Tsvm2,AUCsvm2,Opt2] = perfcurve(inds_VILI,VILI1,'true');
% [Xsvm2,Ysvm2,Tsvm2,AUCsvm2,Opt2] = perfcurve(inds_VILI,VILI1,'true');
% 
 [Xsvm3,Ysvm3,Tsvm3,AUCsvm3,Opt3] = perfcurve(inds_VILI,combinedpar,'true');
 %[Xsvm4,Ysvm4,Tsvm4,AUCsvm4,Opt4] = perfcurve(inds_VILI,combinedser,'true');
%[Xsvm4,Ysvm4,Tsvm4,AUCsvm4,Opt4] = perfcurve(inds_VILI,VILI1,'true');

%[Xsvm5,Ysvm5,Tsvm5,AUCsvm5,Opt5] = perfcurve(inds,combinedold,'true');
%%
%plot ROC overall
phys1se=0.781;
phys1sp=0.371;
phys2se=0.683;
phys2sp=0.286;
phys3se=0.889;
phys3sp=0.80;

%lowgrade
% phys1se=0.732;
% phys1sp=0.371;
% phys2se=0.575;
% phys2sp=0.286;
% phys3se=0.925;
% phys3sp=0.80;

% highgrade
% phys1se=0.87;
% phys1sp=0.371;
% phys2se=0.87;
% phys2sp=0.286;
% phys3se=0.826;
% phys3sp=0.80;
%%
figure;x=[0:1];
y=x;
plot(x,y,'k--')
hold on
%plot(Xsvm,Ysvm,'b-','linewidth',2)
%plot(Xsvm2,Ysvm2,'r-','linewidth',2)
 plot(Xsvm3,Ysvm3,'b-','linewidth',5)
%  plot(Xsvm4,Ysvm4,'r-','linewidth',2)

 physse=[phys1se,phys2se,phys3se];
 physsp=[phys1sp,phys2sp,phys3sp];
% plot(Xsvm5,Ysvm5,'b-','linewidth',2)

plot(physsp,physse,'ko','MarkerFaceColor','k', 'MarkerSize',10)
hold off
% legend('Random chance',['VIA=',num2str(AUCsvm)],['Old VILI=',num2str(AUCsvm4)],['New VILI=',num2str(AUCsvm2)],['Old Combined=',num2str(AUCsvm5)],['New Combined=',num2str(AUCsvm3)],'Physician 1', 'Physician 2','Physcian 3','Location','southeast')
legend('Random chance',['Calla AI = 0.86'],'Physicians','Location','southeast')
%legend('Random chance',['VIA only=',num2str(AUCsvm)],['VIA + VILI=',num2str(AUCsvm3)],'Physicians','Location','southeast')
        
xlabel('1-Specificity')
ylabel('Sensitivity')
title('Normal vs Abnormal')
%savefig('normvshigh.fig')

    %%
dirlist = dir('*.tif');
name = {dirlist.name}.';        
a= {dirlist.name}.';
a=string(a);
a=string(a);