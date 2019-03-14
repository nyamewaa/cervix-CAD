function[label,score]=via_pred(image,mdl_via)
%image = imread(image); 
%imshow(image);
%%
cervix_crop=image;
de_spec=Remove_specular_refl(cervix_crop);
%%
[gab_roi,gab_rect]=gabor_segment(de_spec);
%%
color_feat=color_feature_fun(gab_roi);
texture_feat=haralick_feature_fun(gab_rect);
gab_feat=[1,1,1];
all_feats=[texture_feat,gab_feat,color_feat];

%VIA features
via_feat=all_feats([11,16,31,3,2,28]);
%%
 model=mdl_via;
[label,score]=predict(model,via_feat);
end
