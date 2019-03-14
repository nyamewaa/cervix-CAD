%% plots
%load concordance
biop=cellstr(BiopsyBinary);%(:,6);
algorithm=cellstr(AlgorithmClassification);%physconsbio22(:,8);
%physician=cellstr( LisaMuasher);%physconsbio22(:,2);JohnSchmittGT  LisaMuasher

%biop=Pathologybinary1([1:134]);%([386:512],:));%phys2([1:134],6);
%algorithm=cellstr(vili([2:135],:));%([386:512],:));%phys2([1:134],9);
%physician=combined([1:134]);%([386:512],:));
%% This is used to plot phys sentivity
%find sensitivity and spec for biop
CP_alg_biop=classperf(biop,algorithm,'Positive','Positive','Negative','Negative');
% CP_phys_biop=classperf(biop,physician,'Positive','Positive','Negative','Negative');
%CP_alg_phys=classperf(physician,algorithm,'Positive','Positive','Negative','Negative');

%%
% plot((1-CP_s_con.Specificity),CP_s_con.Sensitivity,'bs','MarkerSize',10,'MarkerFaceColor','b')%schmitt overall
% plot((1-CP_p_con.Specificity),CP_p_con.Sensitivity,'go','MarkerSize',10,'MarkerFaceColor','g')%peyton overall
% plot((1-CP_m_con.Specificity),CP_m_con.Sensitivity,'mp','MarkerSize',10,'MarkerFaceColor','m') %Muasher overall
% plot((1-CP_v_con.Specificity),CP_v_con.Sensitivity,'rd','MarkerSize',10,'MarkerFaceColor','r')%venegas overall
% legend(['SAUC=',num2str(AUCsvmtest)],['LAUC=',num2str(AUClog)],'Random chance','Physician 1','Physician 2', 'Physician 3','Physician 4')%change
% set(gca,'FontSize',18);
% xlabel('1-Specificity','FontSize',16); ylabel('Sensitivity','FontSize',16);
% title('ROC for normal vs abnormal test data')%change
% hold off

%%
%calculate kappa 
cmat_a=confusionmat(biop,algorithm)%alg vs biopsy
kappa(cmat_a,0,0.05)
cmat_s=confusionmat(biop,physician)%phys 1 vs biopsy
kappa(cmat_s,0,0.05)
cmat_p=confusionmat(physician,algorithm)
kappa(cmat_p,0,0.05)


