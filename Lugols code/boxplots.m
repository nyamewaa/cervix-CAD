labels_biop1=cellstr(Gino2([1:133],:));%physicians22([1:134],13);
labels_biop=labels_biop1';
data=[gino_neg;gino_pos];
inds= ~strcmp(labels_biop1,'Negative');
negative = data(inds==0,:);%,:);
positive = data(inds==1,:);
x%% Boxlot
figure;
% x1=double(X_colponeg(:,66))'.*100;
% x2=double(X_colpopos(:,66))'.*100;
% x1=double(lesion_neg)'.*100;
% x2=double(lesion_pos)'.*100;
x1=negative(:,6);
x2=positive(:,6);
group = [repmat({'First'}, 50, 1); repmat({'Second'}, 83, 1)];
boxplot([x1; x2],group,'labels',{'VILI-','VILI+'})
ylabel('b mean')
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


