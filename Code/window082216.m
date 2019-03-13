% clc,clear all, close all
% cd('C:\Users\mna14\Desktop\acetowhitening margin\windowimg\norm_Despec');
%folder='C:\Users\mna14\Desktop\Research\Lugols image processing\Revised_code_all_images\La Liga\despec\cropped\minbound\gabor\gabor_minbound';
 folder='X:\Mercy\Image processing\VIA image processing\Honduras\cervix_boxcrop\Despec\Clear Pos\gabRECT';
 img='L41.jpg';%%%
 fullfilename=fullfile(folder, img);
image=imread(fullfilename);
imshow(image);
I=rgb2gray(image);
% name='cervix34';%%%
%load('C:\Users\mna14\Desktop\acetowhitening margin\windowimg\norm_Despec\lesionmatfiles\cervix2.mat');%% 
%%      
win=10;
% load('lugolmask.mat');
%% MEAN red PIXEL VALUE finds mwN PPIX WITH BLOACK PROC GETS the values
myfun = @(block_struct) ...
   uint8(mean(mean(block_struct.data)));
I2_a=blockproc(image,[win win],myfun);
size_mat=size(I2_a,2)*size(I2_a,1);
I2_array=reshape(I2_a',size_mat,1);

% lesionmask=imresize(AllLesionsMask1,[size(I2_a,1) size(I2_a,2)]);
% lesion_index=find(lesionmask);
% nonlesion_index=find(lesionmask==0);

% I2_lesion=I2_array(lesion_index);
% I2_nonlesion=I2_array(nonlesion_index);

%save([name,'pixelarray'],'I2_array');
% save([name,'pixellesion'],'I2_lesion');
% save([name,'pixelnonlesion'],'I2_nonlesion');
 %%  finds the position for the values and can show the image
myfun = @(block_struct) ...
   uint8(mean2(block_struct.data)*...
   ones(size(block_struct.data)));
[I2,r,c]=blockproc_with_loc(image,[win win],myfun);
%%
% size_mat=size(I2,2)*size(I2,1);
r_array=reshape(r',size_mat,1);
c_array=reshape(c',size_mat,1);
I2_array=reshape(I2_a',size_mat,1);
% I2_lesion=I2_array(lesion_index);
% I2_nonlesion=I2_array(nonlesion_index);

%%
position=cat(2,c_array,r_array);
%%
% RGB = insertText(image,position,I2_array,'FontSize',50);
figure
imshow(I2),title('Numeric values');

%% CORRELATE
myfun = @(block_struct) ...
   correlate(block_struct.data);
I3_a=blockproc(I,[win win],myfun);
size_mat=size(I3_a,2)*size(I3_a,1);
I3_array=reshape(I3_a',size_mat,1);
% I3_lesion=I3_array(lesion_index);
% I3_nonlesion=I3_array(nonlesion_index);
%save([name,'corrarray'],'I3_array');
% save([name,'corrlesion'],'I3_lesion');
% save([name,'corrnonlesion'],'I3_nonlesion');
 %%  
myfun = @(block_struct) ...
   (correlate(block_struct.data)*...
   ones(size(block_struct.data)));
[I3,r,c]=blockproc_with_loc(image,[win win],myfun);

r_array=reshape(r',size_mat,1);
c_array=reshape(c',size_mat,1);
%%
position=cat(2,c_array,r_array);
%%
% RGB = insertText(image,position,I3_array,'FontSize',30);
% figure
% imshow(RGB),title('Numeric values');

%% HOMOGENEITY
myfun = @(block_struct) ...
   homogeneity(block_struct.data);
I4les_a=blockproc(I,[win win],myfun);
% size_mat=size(I4_a,2)*size(I4_a,1);
% I4_array=reshape(I4_a',size_mat,1);
% I4_lesion=I4_array(lesion_index);
% I4_nonlesion=I4_array(nonlesion_index);
%save([name,'homoarray'],'I4_array');
% save([name,'homolesion'],'I4_lesion');
% save([name,'homononlesion'],'I4_nonlesion');
%%
c = jet;
c = flipud(c);
imagesc(I4les_a);colormap(c);;colorbar;caxis([0,0.2])
 %%  
myfun = @(block_struct) ...
  (homogeneity(block_struct.data)*...
   ones(size(block_struct.data)));
[I4,r,c]=blockproc_with_loc(image,[win win],myfun);

r_array=reshape(r',size_mat,1);
c_array=reshape(c',size_mat,1);
%%
position=cat(2,c_array,r_array);
%%
% RGB = insertText(image,position,I4_array,'FontSize',20);
% figure
% imshow(RGB),title('Numeric values');

%% CONTRAST
myfun = @(block_struct) ...
   contrast(block_struct.data);
I5_a=blockproc(image,[win win],myfun);
size_mat=size(I5_a,2)*size(I5_a,1);
I5_array=reshape(I5_a',size_mat,1);
% I5_lesion=I5_array(lesion_index);
% I5_nonlesion=I5_array(nonlesion_index);
save([name,'contrastarray'],'I5_array');
% save([name,'contrastlesion'],'I5_lesion');
% save([name,'contrastnonlesion'],'I5_nonlesion');
 %%  
myfun = @(block_struct) ...
   (contrast(block_struct.data)*...
   ones(size(block_struct.data)));
[I5,r,c]=blockproc_with_loc(image,[win win],myfun);

r_array=reshape(r',size_mat,1);
c_array=reshape(c',size_mat,1);
%%
position=cat(2,c_array,r_array);
%%
% RGB = insertText(image,position,I5_array,'FontSize',20);
% figure
% imshow(RGB),title('Numeric values');

%% ENERGY
myfun = @(block_struct) ...
   (energy(block_struct.data));
I6norm_a=blockproc(I,[win win],myfun);
%size_mat=size(I6_a,2)*size(I6_a,1);
%I6_array=reshape(I6_a',size_mat,1);
% I6_lesion=I6_array(lesion_index);
% I6_nonlesion=I6_array(nonlesion_index);
%save([name,'energyarray'],'I6_array');
% save([name,'energylesion'],'I6_lesion');
% save([name,'energynonlesion'],'I6_nonlesion');
 %%  
myfun = @(block_struct) ...
   (energy(block_struct.data)*...
   ones(size(block_struct.data)));
[I6,r,c]=blockproc_with_loc(image,[win win],myfun);

r_array=reshape(r',size_mat,1);
c_array=reshape(c',size_mat,1);
%%
position=cat(2,c_array,r_array);
%%
% RGB = insertText(image,position,I6_array,'FontSize',20);
% figure
% imshow(RGB),title('Numeric values');
%% Images



%% PLOTS
%I2=mean pixel, i3=correlate  i4=homo  i5=contrast  i6=energy
figure;plot(I2_array,I5_array,'*b')
% hold on
% plot(I2_array,I6_array,'*b')
% hold off
title('Pix mean vs correlate')
xlabel('Pix mean')
ylabel('correlate')

% %I2=mean pixel, i3=correlate  i4=homo  i5=contrast  i6=energy
% figure;plot(I2_lesion,I3_lesion,'*r')
% hold on
% plot(I2_nonlesion,I3_nonlesion,'*b')
% hold off
% title('Pix mean vs correlate')
% xlabel('Pix mean')
% ylabel('correlate')
% 
% figure;plot(I2_lesion,I4_lesion,'*r')
% hold on 
% plot(I2_nonlesion,I4_nonlesion,'*b')
% hold off
% title('Pix mean vs homogeneity')
% xlabel('Pix mean')
% ylabel('homogeneity')
% 
% figure;plot(I2_lesion,I5_lesion,'*r')
% hold on
% plot(I2_nonlesion,I5_nonlesion,'*b')
% hold off
% title('Pix mean vs contrast')
% xlabel('Pix mean')
% ylabel('contrast')
% 
% figure;plot(I2_lesion,I6_lesion,'*r')
% hold on
% plot(I2_nonlesion,I6_nonlesion,'*b')
% hold off
% title('Pix mean vs energy')
% xlabel('Pix mean')
% ylabel('energy')
% 
% figure;plot(I3_lesion,I4_lesion,'*r')
% hold on
% plot(I3_nonlesion,I4_nonlesion,'*b')
% hold off
% title('correlate vs homogeneity')
% xlabel('correlate')
% ylabel('homogeneity')
% 
% figure;plot(I3_lesion,I5_lesion,'*r')
% hold on 
% plot(I3_nonlesion,I5_nonlesion,'*b')
% hold off
% title('correlate vs contrast')
% xlabel('correlate')
% ylabel('contrast')
% 
% figure;plot(I3_lesion,I6_lesion,'*r')
% hold on
% plot(I3_nonlesion,I6_nonlesion,'*b')
% hold off
% title('correlate vs energy')
% xlabel('correlate')
% ylabel('energy')
% 
% figure;plot(I4_lesion,I5_lesion,'*r')
% hold on 
% plot(I4_nonlesion,I5_nonlesion,'*b')
% hold off
% title('homogeneity vs contrast')
% xlabel('homogeneity')
% ylabel('contrast')
% 
% figure;plot(I4_lesion,I6_lesion,'*r')
% hold on
% plot(I4_nonlesion,I6_nonlesion,'*b')
% hold off
% title('homogeneity vs energy')
% xlabel('homogeneity')
% ylabel('energy')
% 
% figure;plot(I5_lesion,I6_lesion,'*r')
% hold on
% plot(I5_nonlesion,I6_nonlesion,'*b')
% hold off
% title('contrast vs energy')
% xlabel('contraste')
% ylabel('energy')