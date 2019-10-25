
%%
%rgb
%folder = 'C:\Users\mna14\Desktop\Research\Lugols image processing\Revised_code_all_images\La Liga\despec\cropped\minbound\';
dirlist = dir('*.tif');
%for n=1:2%length(dirlist) 
img = imread('W74.tif');%(dirlist(n).name);  
%filename=dirlist(n).name;
 figure; imshow(img)
%%
% blue_img = img(:, :, 3);
% bw=blue_img<220;
% img2=uint8(double(img).* double(repmat(bw, [1 1 3])));
%  imshow(img2)
% 
% green_img=img(:,:,3);%rgb2gray(img);%
% green_list=green_img(:);
% green_img_ind=find(green_list>0);
% nonzero_green=green_list(green_img_ind);

%% b wins
%lab
ycbcr = rgb2ycbcr(img);
cb=ycbcr(:,:,2);
% figure;
imagesc(cb);colormap('jet');colorbar;%caxis([100 150])
%%
lesion_ind=cb>133;
imshow(img, 'InitialMag', 'fit')
green = cat(3, zeros(size(cb)),ones(size(cb)), zeros(size(cb)));
hold on
h = imshow(green);
hold off
set(h, 'AlphaData', lesion_ind)
% saveas(gcf,[folder 'cervix_lesion\' filename])
% close all
%% Calculate size
lesion_factors=find(lesion_ind);
lesion_size=size(lesion_factors,1);
cervix_ind=find(img);
cervix_size=size(cervix_ind,1);
lesion_percent(n)=(lesion_size/cervix_size);

 %end
save('lesionsize.mat','lesion_percent')