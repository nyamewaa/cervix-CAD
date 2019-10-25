%%
clc, clear all
folder='X:\Mercy\VIA image processing\images\despec\bound_crop\gabor_roi\';
dirlist = dir('*.mat');
for n=1:length(dirlist)
load(dirlist(n).name);  
norm_feat_list=norm_feat(:);
gab_mean(n)=mean(norm_feat_list);
gab_med(n)=median(norm_feat_list);
gab_var(n)=var(norm_feat_list);
% gab_mode(n)=mode(norm_feat_list);
gab_feat(n,:)=[gab_mean(n),gab_med(n),gab_var(n)];%,gab_mode(n)];

end
save('gab_feat.mat','gab_feat')