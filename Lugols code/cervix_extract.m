
% cd('C:\Users\mna14\Desktop\Cevix Image processing');
 folder='X:\Mercy\VIA image processing\Duke AA\despec\cervix_crop\';
 filename='X:\Mercy\VIA image processing\Duke AA\despec\';

for n=214:218%length(dirlist)
    %read in data 
    name=['W',num2str(n),'.tif'];
    fullfilename=fullfile(filename, name);
    image=imread(fullfilename);
    img=image(:,:,1:3);
    load(['X:\Mercy\VIA image processing\Duke AA\despec\cervix_mask\W',num2str(n),'.tif.mat'])
    cervix_crop=uint8(double(img).* repmat(AllLesionsMask1, [1 1 3]));
    imshow(cervix_crop)
    %print ('-djpeg','-r300',[folder '/cropped_cervix/' dirlist(n).name]);
    imwrite(cervix_crop,[folder 'W',num2str(n),'.tif'],'Compression','none','Resolution',300);  
end