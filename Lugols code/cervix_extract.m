% cd('C:\Users\mna14\Desktop\Cevix Image processing');
 folder='C:\Users\mna14\Desktop\Research\Cevix Image processing\Images\Peru\New images\Lugol\segmented\';
 filename='C:\Users\mna14\Desktop\Research\Cevix Image processing\Images\Peru\New images\Lugol\';

for n=177:200%1:length(dirlist)
    %read in data 
    name=['L',num2str(n),'.tif'];
    fullfilename=fullfile(filename, name);
    image=imread(fullfilename);
    img=image(:,:,1:3);

    load(['C:\Users\mna14\Desktop\Research\Cevix Image processing\Images\Peru\New images\Lugol\cervix_mask\L',num2str(n),'.tif.mat'])
    cervix_crop=uint8(double(img).* repmat(AllLesionsMask1, [1 1 3]));
    %print ('-djpeg','-r300',[folder '/cropped_cervix/' dirlist(n).name]);
    imwrite(cervix_crop,[folder 'L',num2str(n),'.tif'],'Compression','none','Resolution',300);  
end