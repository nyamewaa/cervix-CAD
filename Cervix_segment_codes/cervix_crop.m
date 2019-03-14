close all; clear all;
cd('X:\Mercy\Image processing\VIA image processing\Honduras');
dirlist = [dir('*.tif');dir('*.jpg');dir('*.png')];
cd('X:\Mercy\Image processing\Segmentation');
folder='X:\Mercy\Image processing\VIA image processing\Honduras';
for n=50:51 %length(dirlist)
    %read in data
    name=['W',num2str(n),'.jpg'];
    fullfilename=fullfile(folder, name);
    image=imread(fullfilename);
    cervix_boxcrop=imcrop(image);
    filename=['X:\Mercy\Image processing\Segmentation\cervix_boxcrop\L',num2str(n),'.jpg'];
    imwrite(cervix_boxcrop,filename);  
end