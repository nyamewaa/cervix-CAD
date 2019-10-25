close all; clear all;
dirlist = dir('*.tif');%dir('*.tif');
% cd('S:\Nimmi\Cervix Data\Cervix Imaging - Cervix 1 Local');
for i=3:length(dirlist)
    %read in data
    img = imread(dirlist(i).name);
    folder = 'X:\Mercy\VIA image processing\images\despec\'; %Folder where the image is saved
    % image =['L',num2str(i)]; %Image name
    filename=dirlist(i).name;
    
    
    %labimg = rgb2lab(img);
    labimg  = double(rgb2ycbcr(img));
    % Extract individual H, S, and V images
    y = labimg(:,:, 1);
    cb = labimg(:,:, 2);
    cr = labimg(:,:, 3);
%     figure;imagesc(l)
%     figure;imagesc(cb);colorbar
%     figure;imagesc(cr);colorbar
    
    %%
    cervix=cr>155;
    cervix2 = imfill(cervix,'holes');
%     figure;imshow(cervix2)
    
    %% get only dominant blob
    ims = conv2(double(cervix2), ones(7,7),'same');
    imbw = ims>10;
%     figure;imshow(imbw);title('All pixels that there are at least 15 white pixels in their hood');
     Ilabel = bwlabel(imbw);
    props = regionprops(imbw,'Area','PixelIdxList','MajorAxisLength','MinorAxisLength','Centroid','Eccentricity');
    stat = regionprops(Ilabel,'centroid');
%     figure;imshow(imbw); hold on;
%     center=size(imbw)/2;
%     plot(center(2),center(1),'r*')
%     for x = 1: numel(stat)
%         plot(stat(x).Centroid(1),stat(x).Centroid(2),'ro');
%         pos=[stat(x).Centroid(1),stat(x).Centroid(2);center(2),center(1)];
%         d(x) = pdist(pos,'euclidean');
%     end
%     
%     hold off
    
    %%
    [~,indexOfMax] = max([props.Area]);
    approximateRadius =  props(indexOfMax).MajorAxisLength/2;
    largestBlobIndexes  = props(indexOfMax).PixelIdxList;
    bw = false(size(cervix));
    bw(largestBlobIndexes) = 1;
    bw = imfill(bw,'holes');
%     figure; imshow(bw)
    %%
    seD = strel('disk',20);
    BWfinal4 = imerode(bw,seD);
%     figure, imshow(BWfinal4), title('segmented image');
    
    %%
    ims = conv2(double(BWfinal4), ones(7,7),'same');
    imbw = ims>15;
    %figure;imshow(imbw);title('All pixels that there are at least 6 white pixels in their hood');
    props = regionprops(imbw,'Area','PixelIdxList','MajorAxisLength','MinorAxisLength');
    [~,indexOfMax] = max([props.Area]);
    approximateRadius =  props(indexOfMax).MajorAxisLength/2;
    largestBlobIndexes  = props(indexOfMax).PixelIdxList;
    bw2 = false(size(BWfinal4));
    bw2(largestBlobIndexes) = 1;
    bw2 = imfill(bw2,'holes');
%     imshow(bw2)
    %%
    cervix_crop=uint8(double(img).* repmat(bw2, [1 1 3]));
   % figure;imshow(cervix_crop)
    
    save([folder 'auto_mask\' filename '.mat'],'bw2');
    imwrite(cervix_crop,[folder 'auto_crop\' filename,'.tif'],'Compression','none','Resolution',300);
   
end
