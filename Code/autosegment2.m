close all; clear all;
dirlist = dir('*.tif');%dir('*.tif');
% cd('S:\Nimmi\Cervix Data\Cervix Imaging - Cervix 1 Local');
for i=1:length(dirlist)
    %read in data
    img = imread(dirlist(i).name);
    folder = 'C:\Users\mna14\Desktop\Research\Lugols image processing\Revised_code_all_images\KCMC\AA\'; %Folder where the image is saved
    % image =['L',num2str(i)]; %Image name
    filename=dirlist(i).name;
    
    %labimg = rgb2lab(img);
    labimg  = double(rgb2ycbcr(img));
    % Extract individual H, S, and V images
    y = labimg(:,:, 1);
    cb = labimg(:,:, 2);
    cr = labimg(:,:, 3);
    
    cervixy=(100<y) &(y<180);
    cervixcb=cb>120;
    cervixcr=cr>130;
    cervix2= cervixy.*cervixcb;
    cervix3=cervix2.*cervixcr;
    cervix3 = imfill(cervix3,'holes');
    seD1 = strel('disk',2);
    cervix4 = imerode(cervix3,seD1);

    
    
    %% get only dominant blob
    ims = conv2(double(cervix4), ones(7,7),'same');
    imbw = ims>10;
    Ilabel = bwlabel(imbw);
    props = regionprops(imbw,'Area','PixelIdxList','MajorAxisLength','MinorAxisLength','Centroid','Eccentricity');
    stat = regionprops(Ilabel,'centroid');
    
    [~,indexOfMax] = max([props.Area]);
    approximateRadius =  props(indexOfMax).MajorAxisLength/2;
    largestBlobIndexes  = props(indexOfMax).PixelIdxList;
    bw = false(size(cervix3));
    bw(largestBlobIndexes) = 1;
    bw = imfill(bw,'holes');
    
    seD = strel('disk',20);
    BWfinal4 = imerode(bw,seD);

      
    ims = conv2(double(BWfinal4), ones(7,7),'same');
    imbw = ims>15;
    props = regionprops(imbw,'Area','PixelIdxList','MajorAxisLength','MinorAxisLength');
    [~,indexOfMax] = max([props.Area]);
    approximateRadius =  props(indexOfMax).MajorAxisLength/2;
    largestBlobIndexes  = props(indexOfMax).PixelIdxList;
    bw2 = false(size(BWfinal4));
    bw2(largestBlobIndexes) = 1;
    bw2 = imfill(bw2,'holes');

    
    cervix_crop=uint8(double(img).* repmat(bw2, [1 1 3]));
        
    save([folder 'auto_mask\' filename '.mat'],'bw2');
    imwrite(cervix_crop,[folder 'auto_crop\' filename,'.tif'],'Compression','none','Resolution',300);

end
    
    
