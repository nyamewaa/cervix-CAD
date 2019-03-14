function[label,score]=vili_pred(image,mdl_vili)
%image = imread(image);
%imshow(image);
%%
%cervix_crop=image;
de_spec=Remove_specular_refl(cervix_crop);
%%
[gab_roi,gab_rect]=gabor_segment(de_spec);
%%
color_feat=color_feature_fun(gab_roi);
all_feats=[color_feat];

%VILI features
vili_feat=all_feats([60,39]);
%%
model=mdl_vili;
[label,score]=predict(model,vili_feat);
end
