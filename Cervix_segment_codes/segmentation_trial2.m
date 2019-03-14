%% Segment Cervices for Lugols Iodine Images

clc,clear, close all
cd('C:\Users\mna14\Desktop\Progress Reports\acetowhitening margin');
% load('C:\Users\mna14\Desktop\acetowhitening margin\Peru Lugol\cervix_mask\L27_cervix.mat')
folder='C:\Users\mna14\Desktop\Progress Reports\acetowhitening margin\Peru Lugol\Lugol\abnormal_pink_yellow_brown';
img='L10.tif';
fullfilename=fullfile(folder, img);
image=(imread(fullfilename));
red = image(:,:,1); % Red channel
green = image(:,:,2); % Green channel
blue = image(:,:,3); % Blue channel
grey=green;%rgb2gray(image);
figure;imshow(image)
%% sobel threshold 
[~, threshold] = edge(grey, 'canny');
fudgeFactor = 3;
BWs = edge(grey,'canny', threshold * fudgeFactor);
figure, imshow(BWs), title('binary gradient mask');

%% fill holes and dilate first round
se90 = strel('line',10, 90);
se0 = strel('line', 10, 0);
BWsdil = imdilate(BWs, [se90 se0]);
figure, imshow(BWsdil), title('dilated gradient mask');

BWdfill = imfill(BWsdil, 'holes');
figure, imshow(BWdfill);
title('binary image with filled holes');

BWnobord = imclearborder(BWdfill, 6);
figure, imshow(BWnobord), title('cleared border image');
%% fill holes and dilate second round
se90 = strel('line', 10, 90);
se0 = strel('line', 10, 0);
se15 = strel('line', 10, 15);
se45 = strel('line', 10, 45);
BWsdil2 = imdilate(BWnobord, [se90 se0]);
figure, imshow(BWsdil2), title('dilated gradient mask');

BWdfill2 = imfill(BWsdil2, 'holes');
figure, imshow(BWdfill2);
title('binary image with filled holes');

BWnobord2 = imclearborder(BWdfill2, 4);
figure, imshow(BWnobord2), title('cleared border image');
%% fill holes and dilate third round
se90 = strel('line', 20, 90);
se0 = strel('line', 20, 0);
BWsdil3 = imdilate(BWnobord2, [se90 se0]);
figure, imshow(BWsdil3), title('dilated gradient mask');

BWdfill3 = imfill(BWsdil3, 'holes');  
figure, imshow(BWdfill3);
title('binary image with filled holes');

 BWnobord3 = imclearborder(BWdfill3, 4);
 figure, imshow(BWnobord3), title('cleared border image');
 %% fill holes and dilate third round
se90 = strel('line', 100, 90);
se0 = strel('line', 100, 0);
BWsdil4 = imdilate(BWnobord3, [se90 se0]);
figure, imshow(BWsdil4), title('dilated gradient mask');

BWdfill4 = imfill(BWsdil4, 'holes');  
figure, imshow(BWdfill4);
title('binary image with filled holes');

%  BWnobord4 = imclearborder(BWdfill4, 4);
%  figure, imshow(BWnobord4), title('cleared border image');
%% get only dominant blob
 ims = conv2(double(BWdfill4), ones(7,7),'same');
    imbw = ims>15;
    figure;imshow(imbw);title('All pixels that there are at least 6 white pixels in their hood');
  props = regionprops(imbw,'Area','PixelIdxList','MajorAxisLength','MinorAxisLength');
    [~,indexOfMax] = max([props.Area]);
    approximateRadius =  props(indexOfMax).MajorAxisLength/2;
 largestBlobIndexes  = props(indexOfMax).PixelIdxList;
    bw = false(size(BWnobord3));
    bw(largestBlobIndexes) = 1;
    bw = imfill(bw,'holes');
    figure;imshow(bw);title('Leaving only largest blob and filling holes');
    figure;imshow(edge(bw));title('Edge detection');
        %% dilate and fill
  se90 = strel('line', 250, 90);
se0 = strel('line', 250, 0);
BWsdil5 = imdilate(bw, [se90 se0]);
figure, imshow(BWsdil5), title('dilated gradient mask');
BWdfill5 = imfill(BWsdil5, 'holes');
figure, imshow(BWdfill5);
title('binary image with filled holes');

    
%% smooth
seD = strel('disk',2);
BWfinal4 = imerode(BWdfill5,seD);
BWfinal4 = imerode(BWfinal4,seD);
figure, imshow(BWfinal4), title('segmented image');
%% outline
BWoutline = bwperim(BWfinal4);
Segout = grey;
Segout(BWoutline) = 255;
figure, imshow(Segout), title('outlined original image');
    %%
        radiuses = round ( (approximateRadius-5):0.5:(approximateRadius+5) );
    h = circle_hough(edge(BWfinal4), radiuses,'same');
    [~,maxIndex] = max(h(:));
    [i,j,k] = ind2sub(size(h), maxIndex);
    radius = radiuses(k);
    center.x = j;
    center.y = i;
    
    figure;imshow(grey);imellipse(gca,[center.x-radius  center.y-radius 2*radius 2*radius]);
    title('Final solution (Shown on initial image)');