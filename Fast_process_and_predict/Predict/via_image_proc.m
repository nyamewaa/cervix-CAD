cd 'X:\Mercy\Image processing\VIA image processing\Honduras\cervix_boxcrop'
dirlist = [dir('*.tif');dir('*.jpg');dir('*.png')];
mdl_via=load('viaMdl.mat');
mdl_via=mdl_via.mdlSVM;
for n=1:length(dirlist)
    cd 'X:\Mercy\Image processing\VIA image processing\Honduras\cervix_boxcrop'
    image = imread(dirlist(n).name);
    %imshow(image);
    %%
    cd 'X:\Mercy\Image processing\VIA image processing\Predict'
    cervix_crop=image;
    de_spec=Remove_specular_refl(cervix_crop);
    %%
    [gab_roi,gab_rect]=gabor_segment(de_spec);
    %%
    color_feat=color_feature_fun(gab_roi);
    texture_feat=haralick_feature_fun(gab_rect);
    gab_feat=[1,1,1];
    all_feats=[texture_feat,gab_feat,color_feat];
   
end
cd 'X:\Mercy\Image processing\VIA image processing\Honduras\cervix_boxcrop'
save('predicted.mat','prediction')