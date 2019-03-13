% clc; clear all
%%
 dirlist = dir('*.tif');
for n=1:length(dirlist) 
%  %% read and display input image
img_name = dirlist(n).name;
% img_name = 'W60.tif';
A = imread(img_name);
A = imresize(A,0.25);
Agray = rgb2gray(A);
%figure
%imshow(A)

%% Design gabor filter array
%%

imageSize = size(A);
numRows = imageSize(1);
numCols = imageSize(2);

wavelengthMin = 4/sqrt(2);
wavelengthMax = hypot(numRows,numCols);
n = floor(log2(wavelengthMax/wavelengthMin));
wavelength = 2.^(0:(n-2)) * wavelengthMin;

deltaTheta = 45;
orientation = 0:deltaTheta:(180-deltaTheta);

g = gabor(wavelength,orientation);

gabormag = imgaborfilt(Agray,g); %magnitude features


%% Post processing, gaussian filter
%%

 for i = 1:length(g)
    sigma = 0.5*g(i).Wavelength;
    K = 3;
    gabormag(:,:,i) = imgaussfilt(gabormag(:,:,i),K*sigma); 
 end
 
X = 1:numCols;
Y = 1:numRows;
[X,Y] = meshgrid(X,Y);
featureSet = cat(3,gabormag,X);
featureSet = cat(3,featureSet,Y);

numPoints = numRows*numCols;
X = reshape(featureSet,numRows*numCols,[]);

X = bsxfun(@minus, X, mean(X));
X = bsxfun(@rdivide,X,std(X));

coeff = pca(X);
feature2DImage = reshape(X*coeff(:,1),numRows,numCols);
f=feature2DImage ;
norm_feat=(f-min(min(f)))./(max(max(f))-min(min(f)));
figure;imagesc(norm_feat);colormap('jet');colorbar;caxis([0,1])
folder='C:\Users\mna14\Desktop\Research\Lugols image processing\Revised_code_all_images\Duke\lugols\despec\minbound\';
saveas(gcf,[folder 'gabor_map\' img_name])
close all

%% Classify gabor texture using k means with k=2
%%

nclusters=2;
[L, val] = kmeans(X,nclusters,'Replicates',5);

L = reshape(L,[numRows numCols]);
%figure;imshow(label2rgb(L))
%% Select appropriate cluster
%%

sum_val=sum(val, 2);
[max_val, Ind]=max(sum_val);
pixel_labels = reshape(L,[numRows numCols]);
segmented_images = cell(1,2);
rgb_label = repmat(pixel_labels,[1 1 3]);

for k = 1:nclusters
    color = A;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end

right_cluster=segmented_images{Ind}; 
%figure;imshow(right_cluster)
%%
% 
% Aseg1 = zeros(size(A),'like',A);
% Aseg2 = zeros(size(A),'like',A);
% BW = L == 2;
% BW = repmat(BW,[1 1 3]);
% Aseg1(BW) = A(BW);
% Aseg2(~BW) = A(~BW);
% figure
% imshowpair(Aseg1,Aseg2,'montage');

%% Multiply by cervix mask
%%

% load(['C:\Users\mna14\Desktop\Research\VIA image processing\images\despec\cervix_mask\',img_name,'.mat'])
% CervixMask1= imresize(CervixMask1, 0.25);

% cervix_crop=uint8(double(right_cluster).* repmat(CervixMask1, [1 1 3]));
% %imshow(cervix_crop)

%% Remove stray objects
%%
bin_cer_crop = imbinarize(rgb2gray(right_cluster));
%imshow(bin_cer_crop)
props = regionprops(bin_cer_crop, 'BoundingBox','Area','PixelIdxList');
[~,indexOfMax] = max([props.Area]);
largestBlobIndexes  = props(indexOfMax).PixelIdxList;
bw = false(size(bin_cer_crop));
bw(largestBlobIndexes) = 1;
cervix_crop=uint8(double(right_cluster).* repmat(bw, [1 1 3]));
%imshow(cervix_crop)
% rectangle('Position',[props(indexOfMax).BoundingBox(1), props(indexOfMax).BoundingBox(2),props(indexOfMax).BoundingBox(3), props(indexOfMax).BoundingBox(4)],'EdgeColor','r','LineWidth',2)
folder='C:\Users\mna14\Desktop\Research\Lugols image processing\Revised_code_all_images\Duke\lugols\despec\minbound\gabor_crop\';
imwrite(cervix_crop,[folder img_name])%,'Compression','none','Resolution',300); 
%% Apply minimum bounding box and multiply by cervix
rect_crop=imcrop(A,[props(indexOfMax).BoundingBox(1), props(indexOfMax).BoundingBox(2),props(indexOfMax).BoundingBox(3), props(indexOfMax).BoundingBox(4)]);
folder='C:\Users\mna14\Desktop\Research\Lugols image processing\Revised_code_all_images\Duke\lugols\despec\minbound\gabor_bound\';
imwrite(rect_crop,[folder img_name])%,'Compression','none','Resolution',300); 
% figure;imshow(rect_crop)
end