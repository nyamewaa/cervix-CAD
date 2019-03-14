%lugolProbMap
% To run, navigate MATLAB to the folder in which the images are contained 
clc, clear all
dirlist = dir('*.tif');
for n=1:length(dirlist) 
    %read in data
    img = imread('L99.tif');    
    
    %find areas of spec reflection using blue channel
    blue_img = img(:, :, 3); 
    despec_index=find(blue_img(:) < 220); 
    %%
    %find corresponding despeckled areas in green channel
    green_img=img(:,:,2);%rgb2gray(img);%
    green_list=green_img(:);
    despec_ind=find(green_img<255);
    green_despec=green_list(despec_index);
    %%
    % find areas not equal to 0
    green_img_ind=find(green_list>0);
    nonzero_green=green_list(green_img_ind);
    
    dezero_ind=find(green_despec>0);
    green_dezero=green_despec(dezero_ind);
    green_new_ind=find(green_dezero < 240);
    green_new=green_dezero(green_new_ind);
    %%
    % find stats
    median_img(n)=median(double(green_new));
    mean_img(n)=mean(double(green_new));
    var_img(n)=var(double(green_new));
    mode_img(n)=mode(double(green_new));
    %%
    level_lugol = multithresh(nonzero_green);
    lugol_seg = imquantize(green_img,level_lugol);
   figure;imshow(lugol_seg,[])
%      lugol_seg = imquantize(green_img,level_lugol([4:6]));
  lugol_seg(lugol_seg==1)=0;
     lugol_seg(lugol_seg==2)=1;
     lugol_seg=logical(lugol_seg);
     figure;imshow(lugol_seg,[])
     
       figure;
    imshow(green_img, 'InitialMag', 'fit')
    green = cat(3, zeros(size(green_img)),ones(size(green_img)), zeros(size(green_img))); 
    hold on
    h = imshow(green);
    hold off
    set(h, 'AlphaData', lugol_seg)
%     lugol_seg = graythresh(green_img,level_lugol(n));
    %%
    level(n) = 120;%graythresh(green_new);
     BW = im2bw(green_img,level(n));
    BW(blue_img>240)=0;
    BW(green_img>240)=0;
%     imshow(BW)
    figure;
    imshow(green_img, 'InitialMag', 'fit')
    green = cat(3, zeros(size(green_img)),ones(size(green_img)), zeros(size(green_img))); 
    hold on
    h = imshow(green);
    hold off
    set(h, 'AlphaData', BW)
    
%     imagesc(rgb2gray(imread('L96.tif'))); colormap('jet')
    
    % show images
%        lugol_seg = imquantize(green_img,level_lugol(n));
%       figure;imshow(lugol_seg,[])
%      pause
%      title(strcat(dirlist(n).name, {' '}, 'Green mask '));
%       figure;histogram(green_new)
%       title(strcat(dirlist(n).name, {' '}, 'Green mask '));
%       figure; imshow(img); 
%      title(strcat(dirlist(n).name, {' '}, 'Green Channel '));
   
    %%
    % find variance of despeckled green image
%     var(n)=var(double(green_despec>0));
% 
%     
%     % find variance of despeckled green image
%     %var_img(n)=var(double(green_img));
%     
% %     level_lugol(n) = multithresh(green_img);
%     lugol_seg = imquantize(green_img,level_lugol(n));
%     figure;imshow(lugol_seg,[])
%     title(strcat(dirlist(n).name, {' '}, 'Green mask '));
%     figure; imagesc(green_img); 
%     title(strcat(dirlist(n).name, {' '}, 'Green Channel '));
%     
%     title(strcat(dirlist(n).name, {' '}, 'Blue Channel w/o specular reflection')); 
% name=['overlay',dirlist(n).name];
%  saveas(gcf,name)
%   save('blue.mat','level','level_lugol','median_img','mean_img','var_img','mode_img')
%   close all
%end


    
    
   
