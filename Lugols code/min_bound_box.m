dirlist = dir('*.tif');
 for n=1:length(dirlist) 
 %% read and display input image from despec
img_name = dirlist(n).name;
img = imread(img_name);
% img=imresize(img,0.25);

A=load(['X:\Mercy\VIA image processing\Duke AA\despec\cervix_mask\',img_name,'.mat']);
props = regionprops(A.AllLesionsMask1, 'BoundingBox','Area');
[~,I] = max([props.Area]);
%% Apply minimum bounding box to cervix mask and multiply by cervix
roi=imcrop(img,[props(I).BoundingBox(1), props(I).BoundingBox(2),props(I).BoundingBox(3), props(I).BoundingBox(4)]);
folder='X:\Mercy\VIA image processing\Duke AA\despec\minbound\';
imwrite(roi,[folder img_name])%,'Compression','none'); 
figure;imshow(roi)
 end

