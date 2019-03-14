close all; clear all;
cd('C:\Users\mna14\Desktop\Cevix Image processing');
folder='/Users/usamahchaudhary/Documents/TOpS/TOpS Cervix Images/Pocket/';
dirlist = [dir('*.tif');dir('*.jpg');dir('*.png')];
for n=1:length(dirlist)
    %read in data
    name=['L',num2str(n),'.tif'];
    fullfilename=fullfile(folder, name);
    image=imread(fullfilename);
    cervix_crop=imcrop(image);

    load(['/Users/usamahchaudhary/Documents/TOpS/TOpS Cervix Images/Pocket/cervix_mask\L',num2str(n),'_cervix.mat'])
    cervix_crop=uint8(double(img).* repmat(AllLesionsMask1, [1 1 3]));
    %print ('-djpeg','-r300',[folder '/cropped_cervix/' dirlist(n).name]);
    imwrite(cervix_crop,['L',num2str(n),'.tif'],'Compression','none','Resolution',300);  
end