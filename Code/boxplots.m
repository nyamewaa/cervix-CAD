%% Boxlot
figure;
% x1=double(X_colponeg(:,66));
% x2=double(X_colpopos(:,66));
x1=double(cons_neg(:,58)).*100;
x2=double(cons_pos(:,58)).*100;
group = [repmat({'First'}, 55, 1); repmat({'Second'}, 79, 1)];
boxplot([x1; x2],group,'labels',{'VILI-','VILI+'},'Colors','k')
ylabel('V median')
% ylabel('Variance of blue difference chroma (Cb) channel')
set(gca,'FontSize',24,'FontWeight','bold'); 
%%
[h,p]=ttest2(x1,x2)
%%
boxplot([x1, x2],'notch','on','labels',{'Normal'})
hold on 
boxplot([x2],'notch','on','labels',{'Abormal'})
title('Normal vs Abnormal Data for Blue mode (n=26, ab=59)')
ylabel('Green Channel Threshold')


