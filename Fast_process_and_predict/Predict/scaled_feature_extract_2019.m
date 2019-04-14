%Code to extract color and texture features 
%Use to extract color and texture from cervix images 
%Written by Mercy N. Asiedu
%see color_feature_fun and haralick_feature_fun for additional info on
%color features
%Last updated 04/13/2019
folder='X:\Mercy\Image processing\VIA image processing\Processing_without_ectopion\combined_sites_via_gli\Green Light\inv\';
cd 'X:\Mercy\Image processing\VIA image processing\Processing_without_ectopion\combined_sites_via_gli\Green Light\inv'
dirlist = [dir('*.tif');dir('*.jpg');dir('*.png')];
[~,ndx] = natsortfiles({dirlist.name}); % indices of correct order
dirlist = dirlist(ndx);% sort structure using indices

for n=1:length(dirlist)
    cd 'X:\Mercy\Image processing\VIA image processing\Processing_without_ectopion\combined_sites_via_gli\Green Light\inv'
    image = imread(dirlist(n).name);
    filename=dirlist(n).name;
    %imshow(image);
    %%
    %cd 'X:\Mercy\Image processing\VIA image processing\Fast_process_and_predict\Predict'
   % cervix_crop=image;
   % de_spec=Remove_specular_refl(cervix_crop);
    %%
    [gab_roi,gab_rect]=gabor_segment(image);
    %%
     color_feat(n,:)=color_feature_fun(gab_roi);
     texture_feat(n,:)=haralick_feature_fun(gab_rect);
     inv_feats(n,:)=[texture_feat(n,:),color_feat(n,:)];
    imwrite(gab_roi,[folder 'gabROI\' filename])
    imwrite(gab_rect,[folder 'gabRECT\' filename])
end
cd 'X:\Mercy\Image processing\VIA image processing\Processing_without_ectopion\combined_sites_via_gli\Green Light\inv' 
save('inv_feats.mat','inv_feats')%save features as a mat file