%input VIA scores
cd 'X:\Mercy\Image processing\Combinedserial'
mdl_vili=load('viliMdl2.mat');
mdl_vili=mdl_vili.mdlSVM;
mdl_via=load('viaMdl.mat');
mdl_via=mdl_via.mdlSVM;
combinedMdl=load('vilionviaposMdl.mat');
combinedMdl=combinedMdl.mdlSVM;

cd 'X:\Mercy\Image processing\VIA image processing\Peru\images\despec'
dirlist = [dir('*.tif');dir('*.jpg');dir('*.png')];

%%
for n=1:length(dirlist)
    cd 'X:\Mercy\Image processing\VIA image processing\Peru\images\despec'
    via_image = imread(dirlist(n).name);
    cd 'X:\Mercy\Image processing\Combinedserial'
    [via_label,via_score]=via_pred(via_image,mdl_via);
    if via_score(2) < -0.25
        label(n)=via_label;
        score(n)=via_score(1);
    elseif via_score(2) > -0.25
        cd 'X:\Mercy\Image processing\Lugols image processing\Revised_code_all_images\La Liga\despec'
        dirlist2 = [dir('*.tif');dir('*.jpg');dir('*.png')];
        vili_image = imread(dirlist2(n).name);
        cd 'X:\Mercy\Image processing\Combinedserial'
        [vili_label,vili_score]=vili_pred(vili_image,combinedMdl);
        label(n)=vili_label;
        score(n)=vili_score(2);
    end
    prediction(n,:)=[label(n),score(n)];
end
cd 'X:\Mercy\Image processing\VIA image processing\Peru\images\despec'
save('predicted.mat','prediction')

