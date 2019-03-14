
PathName=
FileName=
fullfilename=fullfile(PathName, FileName);
image=imread(fullfilename);
imshow(image);
%%
cervix_crop=imcrop(image)
de_spec=Remove_specular_refl(cervix_crop);
%%
[gab_roi,gab_rect]=gabor_segment(de_spec);
%%
color_feat=color_feature_fun(gab_roi);
texture_feat=haralick_feature_fun(gab_rect);
gab_feat=[1,1,1];
all_feats=[texture_feat,gab_feat,color_feat];

%VIA features
vili_feat=all_feats([9,50,17,16,49,59]);
%%
 model=mdl_via;
[label,score]=predict(model,via_feat);