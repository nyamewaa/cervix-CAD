cd 'X:\Mercy\Image processing\Lugols image processing\Prediction'
mdl_vili=load('viliMdl2.mat');
mdl_vili=mdl_vili.mdlSVM;
cd 'X:\Mercy\Image processing\Lugols image processing\Revised_code_all_images\La Liga\despec'
dirlist = [dir('*.tif');dir('*.jpg');dir('*.png')];
for n=1:length(dirlist)
    cd 'X:\Mercy\Image processing\Lugols image processing\Revised_code_all_images\La Liga\despec'
    image = imread(dirlist(n).name);
    %imshow(image);
    %%
    cd 'X:\Mercy\Image processing\Lugols image processing\Prediction'
    cervix_crop=image;
    de_spec=Remove_specular_refl(cervix_crop);
    %%
    [gab_roi,gab_rect]=gabor_segment(de_spec);
    %%
    color_feat=color_feature_fun(gab_roi);
%     texture_feat=haralick_feature_fun(gab_rect);
%     gab_feat=[1,1,1];
    all_feats=color_feat;
    
    %VIA features
    vili_feat=all_feats([9,50,17,16,49,59]);
    %%
    model=mdl_vili;
    [label,score]=predict(model,vili_feat);
    label1(n)=label;
    score1(n)=score(2);
    prediction(n,:)=[label1(n),score1(n)];
end
cd 'X:\Mercy\Image processing\Lugols image processing\Revised_code_all_images\La Liga\despec'
save('predicted.mat','prediction')