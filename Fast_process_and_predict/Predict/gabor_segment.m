function [gab_crop, rect_crop]= gabor_segment(image)
  %% read and display input image
A = image;
A2 = imresize(A,0.25);
Agray = rgb2gray(A2);

%% Design gabor filter array
imageSize = size(A2);
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

%% Classify gabor texture using k means with k=2
nclusters=2;
[L, val] = kmeans(X,nclusters);

L = reshape(L,[numRows numCols]);
%% Select appropriate cluster
sum_val=sum(val, 2);
[max_val, Ind]=max(sum_val);
pixel_labels = reshape(L,[numRows numCols]);
segmented_images = cell(1,2);
rgb_label = repmat(pixel_labels,[1 1 3]);

for k = 1:nclusters
    color = A2;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end

right_cluster=segmented_images{Ind}; 

%% Remove stray objects
bin_cer_crop = imbinarize(rgb2gray(right_cluster));
props = regionprops(bin_cer_crop, 'BoundingBox','Area','PixelIdxList');
[~,indexOfMax] = max([props.Area]);
largestBlobIndexes  = props(indexOfMax).PixelIdxList;
bw = false(size(bin_cer_crop));
bw(largestBlobIndexes) = 1;
%% Get cropped ROI

%Multiply by actual cervix image
gab_crop=uint8(double(A2).* repmat(bw, [1 1 3]));

%% Apply minimum bounding box and multiply by cervix
rect_crop=imcrop(A2,[props(indexOfMax).BoundingBox(1), props(indexOfMax).BoundingBox(2),props(indexOfMax).BoundingBox(3), props(indexOfMax).BoundingBox(4)]);
end