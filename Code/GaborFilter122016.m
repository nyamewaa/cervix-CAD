%cervix image processing file
%% Read in image
clc,clear all, close all
% cd('C:\Users\mna14\Desktop\acetowhitening margin');
%folder='C:\Users\mna14\Desktop\Research\Cevix Image processing\Images\duke aa images for processing';
%folder='C:\Users\mna14\Desktop\Research\Cevix Image processing\Images\Duke\LO2';
img='W60.tif';
% fullfilename=fullfile(folder, img);
image=imread(img);
%%
image=image;%(:,:,1:3);
image=imresize(image,0.25);
figure
imshow(image)
I=rgb2gray(image);

%% Normalize Image
I2=gray_Normalization(I);
figure
imshow(I2)

%%
%Feature extraction using gabor filter
imageSize = size(I2);
numRows = imageSize(1);
numCols = imageSize(2);

% wavelengthMin = 4/sqrt(2);
% wavelengthMax = hypot(numRows,numCols);
% n = floor(log2(wavelengthMax/wavelengthMin));
% wavelength = 2.^(0:(n-2)) * wavelengthMin;
wavelength =[9];
% orientation = [0,45];
orientation = [0,22.5,45,67.5,90,112.5,135,157.5,180];
 orientation = [0,45,90,135];
%%
len=length(wavelength)*length(orientation);
gaborArray = gabor(wavelength,orientation);
gaborMag = imgaborfilt(I2,gaborArray);
%%
% figure
%   subplot(2,2,1)
for p = 1:len
%         subplot(2,2,p)
%      imshow(gaborMag(:,:,p),[]);
    theta = gaborArray(p).Orientation;
    lambda = gaborArray(p).Wavelength;
%      title(sprintf('Orientation=%d, Wavelength=%d',theta,lambda));
    gab_image(:,:,p)=gaborMag(:,:,p);
end
%%
p_image=sum(gab_image,3);
norm_p=(p_image-min(min(p_image)))./(max(max(p_image))-min(min(p_image)));
figure
imagesc(norm_p)
colormap('jet')
 colorbar
caxis([0 1])
% colorbar
%% Crop image
figure
figure1=imshow(I2)
roi_cervix=impoly;
wait(roi_cervix);
BW=createMask(roi_cervix);
mask=uint8(BW);
cervix=p_image.*double(mask);

%%
level_white = multithresh(p_image);
white_seg = imquantize(p_image,1200);
figure;imshow(white_seg,[])

% %%
% cd('C:\Users\mna14\Desktop\acetowhitening margin');
% folder2='C:\Users\mna14\Desktop\acetowhitening margin\4images';
% img2='norm_wind_despecLaligalugol.tif';
% fullfilename2=fullfile(folder2, img2);
% image2=imread(fullfilename2);
% level_lugol = multithresh(image2);
% lugol_seg = imquantize(image2,level_lugol);
% imshow(lugol_seg,[])
% %%
% lugol_seg(lugol_seg==1 )=0; 
% lugol_seg(lugol_seg==2 )=1;
% white_seg(white_seg==1 )=0; 
% white_seg(white_seg==2 )=1;
% 
% intersect=lugol_seg.*white_seg;
% figure;imshow(intersect)
% %%
% 
% 
% %%
% figure
% imshow(intersect, 'InitialMag', 'fit')
% figure
% imshow(image, 'InitialMag', 'fit')
% red= cat(3, zeros(size(image)), ones(size(image)), zeros(size(image)));
% hold on
% h = imshow(red);
% hold off
% set(h, 'AlphaData',intersect)
% set(gcf, 'Position', get(0,'Screensize'))
% hold on
% h = imshow(intersect~=0);
% hold off
% set(h, 'AlphaData',image)
% set(gcf, 'Position', get(0,'Screensize'))
%%
figure
imshow(image)
% colorbar
hold on
h = imshow(p_image); 
colormap('jet')
colorbar
caxis([0 12])
hold off
set(h, 'AlphaData',cervix)
set(gcf, 'Position', get(0,'Screensize'));

set(gca,'FontSize', 20);
%%
%overlaying image
% subplot(1,2,1)
% imshow(image)
% subplot(1,2,2)
figure
imshow(image)
% colorbar
hold on
h = imagesc(cervix); 
colormap('jet')
colorbar
% caxis([0 100])
hold off
set(h, 'AlphaData',rgb2gray(cervix))
set(gcf, 'Position', get(0,'Screensize'));
%% feature extraction with gray comatrix
glcms = graycomatrix(I2);
stats = graycoprops(glcms)
t1=struct2array(stats)

