% cd('C:\Users\mna14\Desktop\Cevix Image processing');
clc,clear all
folder='C:\Users\mna14\Desktop\Research\VIA image processing\images\despec2\segmented\';
%  filename='C:\Users\mna14\Desktop\Research\VIA image processing\images\despec\';
dirlist = dir('*.tif');%dir('*.tif');
for n=3:length(dirlist)
    %read in data
    name= dirlist(n).name;
    image=imread(name);
    img=image(:,:,1:3);
    
    load(['C:\Users\mna14\Desktop\Research\VIA image processing\images\despec2\cervix_mask\',name,'.mat'])
    cervix_crop=uint8(double(img).* repmat(CervixMask1, [1 1 3]));
    %print ('-djpeg','-r300',[folder '/cropped_cervix/' dirlist(n).name]);
    imwrite(cervix_crop,[folder name],'Compression','none','Resolution',300);
    
    props = regionprops(CervixMask1, 'BoundingBox','Area');
    [~,I] = max([props.Area]);
    %% Apply minimum bounding box to cervix mask and multiply by cervix
    bound_crop=imcrop(img,[props(I).BoundingBox(1), props(I).BoundingBox(2),props(I).BoundingBox(3), props(I).BoundingBox(4)]);
    folder2='C:\Users\mna14\Desktop\Research\VIA image processing\images\despec2\bound_crop\';
    imwrite(bound_crop,[folder2 name],'Compression','none','Resolution',300);
end