clc, clear all
folder='X:\Mercy\Image processing\VIA image processing\Peru\images\used for spec reflection\';
dirlist = dir('*.tif');
for n=1:length(dirlist)

%read and display input image
name= dirlist(n).name;
A=imread(name);
A=imresize(A,0.25);
% A = imread('W5.tif')
Agray = rgb2gray(A);
figure; imshow(A)

%% Design gabor filter array
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
for i = 1:length(g)
    %     gabormag2(:,:,i) = imgaussfilt(gabormag(:,:,i),10);
    sigma = 0.5*g(i).Wavelength;
    K = 3;
    gabormag3(:,:,i) = imgaussfilt(gabormag(:,:,i),K*sigma);
    
end
%%
X = 1:numCols;
Y = 1:numRows;
[X,Y] = meshgrid(X,Y);
featureSet = cat(3,gabormag3,X);
featureSet = cat(3,featureSet,Y);

numPoints = numRows*numCols;
X = reshape(featureSet,numRows*numCols,[]);

X = bsxfun(@minus, X, mean(X));
X = bsxfun(@rdivide,X,std(X));

coeff = pca(X);
feature2DImage = reshape(X*coeff(:,1),numRows,numCols);
f=feature2DImage ;
norm_feat=(f-min(min(f)))./(max(max(f))-min(min(f)));
figure
imagesc(norm_feat);colormap('jet');colorbar;caxis([0,1])
set(gca,'FontSize',18)
save([folder 'gabor_feat\' name '.mat'],'norm_feat');
saveas(gcf,[folder, 'gabor_map\', name])
% close all


     %% Classify gabor texture using k means with k=2
nclusters=2;
[L,val] = kmeans(X,nclusters,'Replicates',5);

L = reshape(L,[numRows numCols]);
figure
imshow(label2rgb(L))

%% Select appropriate cluster

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
figure;imshow(right_cluster)

%% Remove stray objects
bin_cer_crop = imbinarize(rgb2gray(right_cluster));
% imshow(bin_cer_crop)
props = regionprops(bin_cer_crop, 'BoundingBox','Area','PixelIdxList');
[~,indexOfMax] = max([props.Area]);
largestBlobIndexes  = props(indexOfMax).PixelIdxList;
bw = false(size(bin_cer_crop));
bw(largestBlobIndexes) = 1;
 imshow(bw)
%%
%Multiply by actual cervix image
gabor_crop=uint8(double(A).* repmat(bw, [1 1 3]));
imwrite(gabor_crop,[folder,'gabor_crop\', name],'Compression','none','Resolution',300);
%imwrite(bw,[folder,'gabor_crop_mask\', name],'Compression','none','Resolution',300);
save([folder 'gabor_crop_mask\' name '.mat'],'bw');
clear gabormag3
end
 