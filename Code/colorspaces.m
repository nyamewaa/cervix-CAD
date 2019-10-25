clc, clear
%%
%rgb

img2 = imread('L61.jpg');

figure; imshow(img2)
% 
% blue_img = img(:, :, 3);
% bw=blue_img<220;
% img2=uint8(double(img).* double(repmat(bw, [1 1 3])));
% imshow(img2)

green_img=img2(:,:,3);%rgb2gray(img);%
green_list=green_img(:);
green_img_ind=find(green_list>0);
nonzero_green=green_list(green_img_ind);
%% RGB
figure(2);
red=double(img2(:,:,1));
redimg=(red-min(min(red)))./(max(max(red))-min(min(red)));
red=(red-min(min(red)))./(max(max(red))-min(min(red)));
red=red(:);
red=red(green_img_ind);
% red=red(despec_index);
histogram(red,500)
set(gca,'FontSize',24,'FontWeight','bold'); 
xlim([0 1.1])

figure(3);
green=double(img2(:,:,2));
greenimg=(green-min(min(green)))./(max(max(green))-min(min(green)));
green=(green-min(min(green)))./(max(max(green))-min(min(green)));
green=green(:);
green=green(green_img_ind);
% green=green(despec_index);
histogram(green,500)
set(gca,'FontSize',24,'FontWeight','bold'); 
xlim([0 1.1])

figure(4);
blue=double(img2(:,:,3));
blueimg=(blue-min(min(blue)))./(max(max(blue))-min(min(blue)));
blue=(blue-min(min(blue)))./(max(max(blue))-min(min(blue)));
blue=blue(:);
blue=blue(green_img_ind);
% blue=blue(despec_index);
histogram(blue,500)
set(gca,'FontSize',24,'FontWeight','bold'); 
xlim([0 1.1])
%  figure;imshow(img2(:,:,1))
%  figure;imshow(img2(:,:,2))
%  figure;imshow(img2(:,:,3))
figure;imagesc(redimg);colormap('jet');caxis([0 1])
set(gca,'ytick',[],'xtick',[],'FontSize',24,'FontWeight','bold'); 
figure;imagesc(greenimg);colormap('jet');caxis([0 1])
set(gca,'ytick',[],'xtick',[],'FontSize',24,'FontWeight','bold'); 
figure;imagesc(blueimg);colormap('jet');caxis([0 1])
set(gca,'ytick',[],'xtick',[],'FontSize',24,'FontWeight','bold'); 
%%
%grey scale
figure (5);
gray=double(rgb2gray(img2));
grayimg=(gray-min(min(gray)))./(max(max(gray))-min(min(gray)));
gray=(gray-min(min(gray)))./(max(max(gray))-min(min(gray)));
gray=gray(:);
gray=gray(green_img_ind);
% gray=gray(despec_index);
histogram(gray,500)
set(gca,'FontSize',24,'FontWeight','bold'); 
xlim([0 1.1])

figure;imagesc(grayimg);colormap('jet');caxis([0 1])
set(gca,'ytick',[],'xtick',[],'FontSize',24,'FontWeight','bold'); 
%% hsv all and v
figure (6);
H = double(rgb2hsv(img2));
h=H(:,:,1);   
himg=(h-min(min(h)))./(max(max(h))-min(min(h)));
h=(h-min(min(h)))./(max(max(h))-min(min(h)));
h=h(:);
h=h(green_img_ind);
% h=h(despec_index);
histogram(h,500)
set(gca,'FontSize',24,'FontWeight','bold'); 
xlim([0 1.1])

figure(7);
s=H(:,:,2);
simg=(s-min(min(s)))./(max(max(s))-min(min(s)));
s=(s-min(min(s)))./(max(max(s))-min(min(s)));
s=s(:);
s=s(green_img_ind);
% s=s(despec_index);
histogram(s,500)
set(gca,'FontSize',24,'FontWeight','bold'); 
xlim([0 1.1])

figure(8);
v=H(:,:,3);
vimg=(v-min(min(v)))./(max(max(v))-min(min(v)));
v=(v-min(min(v)))./(max(max(v))-min(min(v)));
v=v(:);
v=v(green_img_ind);
% v=v(despec_index);
histogram(v,500)
set(gca,'FontSize',24,'FontWeight','bold'); 
xlim([0 1.1])

%  figure;imagesc(H);colormap('jet');colorbar
 figure;imagesc(himg);colormap('jet');caxis([0 1])
 set(gca,'ytick',[],'xtick',[],'FontSize',24,'FontWeight','bold'); 
 figure;imagesc(simg);colormap('jet');caxis([0 1])
 set(gca,'ytick',[],'xtick',[],'FontSize',24,'FontWeight','bold'); 
 figure;imagesc(vimg);colormap('jet');caxis([0 1])
 set(gca,'ytick',[],'xtick',[],'FontSize',24,'FontWeight','bold'); 

%% ycbcr - al and cb
YCBCR = double(rgb2ycbcr(img2));
figure(9);
Y=YCBCR(:,:,1);
Yimg=(Y-min(min(Y)))./(max(max(Y))-min(min(Y)));
Y=(Y-min(min(Y)))./(max(max(Y))-min(min(Y)));
Y=Y(:);
Y=Y(green_img_ind);
% Y=Y(despec_index);
histogram(Y,500)
set(gca,'FontSize',24,'FontWeight','bold'); 
xlim([0 1.1])

figure(10);
CB=YCBCR(:,:,2);
CBimg=(CB-min(min(CB)))./(max(max(CB))-min(min(CB)));
CB=(CB-min(min(CB)))./(max(max(CB))-min(min(CB)));
CB=CB(:);
CB=CB(green_img_ind);
% CB=CB(despec_index);
histogram(CB,500)
set(gca,'FontSize',24,'FontWeight','bold'); 
xlim([0 1.1])
figure(11);
CR=YCBCR(:,:,3);
CRimg=(CR-min(min(CR)))./(max(max(CR))-min(min(CR)));
CR=(CR-min(min(CR)))./(max(max(CR))-min(min(CR)));
CR=CR(:);
CR=CR(green_img_ind);
% CR=CR(despec_index);
histogram(CR,500)
set(gca,'FontSize',24,'FontWeight','bold'); 
xlim([0 1.1])

% figure;imagesc(YCBCR)
figure;imagesc(Yimg);colormap('jet');caxis([0 1])
set(gca,'ytick',[],'xtick',[],'FontSize',24,'FontWeight','bold'); 
figure;imagesc(CBimg);colormap('jet');caxis([0 1]);colorbar
set(gca,'ytick',[],'xtick',[],'FontSize',24,'FontWeight','bold'); 
figure;imagesc(CRimg);colormap(color);caxis([0 1]);colorbar
set(gca,'ytick',[],'xtick',[],'FontSize',24,'FontWeight','bold'); 

% 
% c=colormap(flipud(colormap('jet')));
% figure;imagesc(CRimg);colormap(c);caxis([0 1]);colorbar
%% b wins
%lab
lab = double(rgb2lab(img2));

figure(12);
l=lab(:,:,1);
limg=(l-min(min(l)))./(max(max(l))-min(min(l)));
l=(l-min(min(l)))./(max(max(l))-min(min(l)));
l=l(:);
l=l(green_img_ind);
% L=L(despec_index);
histogram(l,500)
set(gca,'FontSize',24,'FontWeight','bold'); 
xlim([0 1.1])

figure(13);
a=lab(:,:,2);
aimg=(a-min(min(a)))./(max(max(a))-min(min(a)));
a=(a-min(min(a)))./(max(max(a))-min(min(a)));
a=a(:);
a=a(green_img_ind);
% a=a(despec_index);
histogram(a,500)
set(gca,'FontSize',24,'FontWeight','bold'); 
xlim([0 1.1])

figure(14);
b=lab(:,:,3);
bimg=(b-min(min(b)))./(max(max(b))-min(min(b)));
b=(b-min(min(b)))./(max(max(b))-min(min(b)));
b=b(:);
b=b(green_img_ind);
% b=b(despec_index);
histogram(b,500)
set(gca,'FontSize',24,'FontWeight','bold'); 
xlim([0 1.1])
%%
% figure;imagesc(lab);colormap('jet');caxis([0 1])
figure;imagesc(limg);colormap('jet');caxis([0 1])
set(gca,'ytick',[],'xtick',[],'FontSize',24,'FontWeight','bold'); 
figure;imagesc(aimg);colormap('jet');caxis([0 1])
set(gca,'ytick',[],'xtick',[],'FontSize',24,'FontWeight','bold'); 
figure;imagesc(bimg);colormap('jet');caxis([0 1])
set(gca,'ytick',[],'xtick',[],'FontSize',24,'FontWeight','bold'); 