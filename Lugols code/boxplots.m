%% Boxlot
figure;
% x1=double(X_colponeg(:,66));
% x2=double(X_colpopos(:,66));
x1=double(lesion_neg)'.*100;
x2=double(lesion_pos)'.*100;
group = [repmat({'First'}, 60, 1); repmat({'Second'}, 74, 1)];
boxplot([x1; x2],group,'labels',{'VILI-','VILI+'},'Colors','k')
ylabel('Lesion size (%)')
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


