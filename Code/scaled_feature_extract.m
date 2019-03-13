clc;clear all
%% Extract features
%load('C:\Users\mna14\Desktop\Research\Cevix Image processing\training\coefficients.mat')
dirlist = dir('*.tif');
 for n=1:length(dirlist) 
    %read in data
    img = imread(dirlist(n).name);    
    %find areas of spec reflection using blue channel
     blue_img = img(:, :, 3); 
     despec_index=find(blue_img(:) < 220);  
   %% convert to different color spaces
   %rgb
   red=img(:,:,1);
   green=img(:,:,2);
   blue=img(:,:,3);
   %gray
   gray=rgb2gray(img);
   %hsv
   H = rgb2hsv(img);
   h=H(:,:,1);
   s=H(:,:,2);
   v=H(:,:,3);
   %ycbcr 
   YCBCR = rgb2ycbcr(img);
   Y=YCBCR(:,:,1);
   CB=YCBCR(:,:,2);
   CR=YCBCR(:,:,3);
   %lab
   lab = rgb2lab(img);
   l=lab(:,:,1);
   a=lab(:,:,2);
   b=lab(:,:,3);
   
  %% Despeckle/ remove specular reflection
  red_list=red(:);
    red_despec=red_list(despec_index);
  green_list=green(:);
    green_despec=green_list(despec_index); 
  blue_list=blue(:);
    blue_despec=blue_list(despec_index);
  gray_list=gray(:);
    gray_despec=gray_list(despec_index);  
  h_list=h(:);
     h_despec=h_list(despec_index);  
  s_list=s(:);
    s_despec=s_list(despec_index);  
  v_list=v(:);
    v_despec=v_list(despec_index); 
  Y_list=Y(:);
    Y_despec=Y_list(despec_index);
  CB_list=CB(:);
    CB_despec=CB_list(despec_index);  
  CR_list=CR(:);
    CR_despec=CR_list(despec_index); 
  l_list=l(:);
    l_despec=l_list(despec_index); 
  a_list=a(:);
    a_despec=a_list(despec_index); 
  b_list=b(:);
    b_despec=b_list(despec_index); 
    
 %% Dezero
  img_ind=find(green_list>0);
  dezero_ind=find(green_despec>0);
  
  nonzero_red=red_list(img_ind);
  red_dezero=red_despec(dezero_ind);
  red_new_ind=find(red_dezero < 240);
  red_new=red_dezero(red_new_ind);
 
  nonzero_green=green_list(img_ind);
  green_dezero=green_despec(dezero_ind);
  green_new_ind=find(green_dezero < 240);
  green_new=green_dezero(green_new_ind);
 
  nonzero_blue=blue_list(img_ind);
  blue_dezero=blue_despec(dezero_ind);
  blue_new_ind=find(blue_dezero < 240);
  blue_new=blue_dezero(blue_new_ind);
  
  nonzero_gray=gray_list(img_ind);
  gray_dezero=gray_despec(dezero_ind);
  gray_new_ind=find(gray_dezero < 240);
  gray_new=gray_dezero(gray_new_ind);
  
  nonzero_h=h_list(img_ind);
  h_dezero=h_despec(dezero_ind);
  h_new_ind=find(h_dezero < 240);
  h_new=h_dezero(h_new_ind);
  
  nonzero_s=s_list(img_ind);
  s_dezero=s_despec(dezero_ind);
  s_new_ind=find(s_dezero < 240);
  s_new=s_dezero(s_new_ind);
  
  nonzero_v=v_list(img_ind);
  v_dezero=v_despec(dezero_ind);
  v_new_ind=find(v_dezero < 240);
  v_new=v_dezero(v_new_ind);
  
  nonzero_Y=Y_list(img_ind);
  Y_dezero=Y_despec(dezero_ind);
  Y_new_ind=find(Y_dezero < 240);
  Y_new=Y_dezero(Y_new_ind);
  
  nonzero_CB=CB_list(img_ind);
  CB_dezero=CB_despec(dezero_ind);
  CB_new_ind=find(CB_dezero < 240);
  CB_new=CB_dezero(CB_new_ind);
  
  nonzero_CR=CR_list(img_ind);
  CR_dezero=CR_despec(dezero_ind);
  CR_new_ind=find(CR_dezero < 240);
  CR_new=CR_dezero(CR_new_ind);
  
  nonzero_l=l_list(img_ind);
  l_dezero=l_despec(dezero_ind);
  l_new_ind=find(l_dezero < 240);
  l_new=l_dezero(l_new_ind);
  
  nonzero_a=a_list(img_ind);
  a_dezero=a_despec(dezero_ind);
  a_new_ind=find(a_dezero < 240);
  a_new=a_dezero(a_new_ind);
  
  nonzero_b=b_list(img_ind);
  b_dezero=b_despec(dezero_ind);
  b_new_ind=find(b_dezero < 240);
  b_new=b_dezero(b_new_ind);
  
  %% find stats
  red_median_img(n)=median(double(red_new));
  red_mean_img(n)=mean(double(red_new));
  red_var_img(n)=var(double(red_new));
  red_mode_img(n)=mode(double(red_new));
  red_level_lugol(n) = multithresh(double(nonzero_red));%use non-despeckled image
  
  green_median_img(n)=median(double(green_new));
  green_mean_img(n)=mean(double(green_new));
  green_var_img(n)=var(double(green_new));
  green_mode_img(n)=mode(double(green_new));
  green_level_lugol(n) = multithresh(double(nonzero_green));%use non-despeckled image
  
  blue_median_img(n)=median(double(blue_new));
  blue_mean_img(n)=mean(double(blue_new));
  blue_var_img(n)=var(double(blue_new));
  blue_mode_img(n)=mode(double(blue_new));
  blue_level_lugol(n) = multithresh(double(nonzero_blue));%use non-despeckled image
  
  gray_median_img(n)=median(double(gray_new));
  gray_mean_img(n)=mean(double(gray_new));
  gray_var_img(n)=var(double(gray_new));
  gray_mode_img(n)=mode(double(gray_new));
  gray_level_lugol(n) = multithresh(double(nonzero_gray));%use non-despeckled image
  
  h_median_img(n)=median(double(h_new));
  h_mean_img(n)=mean(double(h_new));
  h_var_img(n)=var(double(h_new));
  h_mode_img(n)=mode(double(h_new));
  h_level_lugol(n) = multithresh(double(nonzero_h));%use non-despeckled image
  
   s_median_img(n)=median(double(s_new));
   s_mean_img(n)=mean(double(s_new));
   s_var_img(n)=var(double(s_new));
   s_mode_img(n)=mode(double(s_new));
   s_level_lugol(n) = multithresh(double(nonzero_s));%use non-despeckled image
   
   v_median_img(n)=median(double(v_new));
   v_mean_img(n)=mean(double(v_new));
   v_var_img(n)=var(double(v_new));
   v_mode_img(n)=mode(double(v_new));
   v_level_lugol(n) = multithresh(double(nonzero_v));%use non-despeckled image
   
   Y_median_img(n)=median(double(Y_new));
   Y_mean_img(n)=mean(double(Y_new));
   Y_var_img(n)=var(double(Y_new));
   Y_mode_img(n)=mode(double(Y_new));
   Y_level_lugol(n) = multithresh(double(nonzero_Y));%use non-despeckled image
   
   CB_median_img(n)=median(double(CB_new));
   CB_mean_img(n)=mean(double(CB_new));
   CB_var_img(n)=var(double(CB_new));
   CB_mode_img(n)=mode(double(CB_new));
   CB_level_lugol(n) = multithresh(double(nonzero_CB));%use non-despeckled image
   
   CR_median_img(n)=median(double(CR_new));
   CR_mean_img(n)=mean(double(CR_new));
   CR_var_img(n)=var(double(CR_new));
   CR_mode_img(n)=mode(double(CR_new));
   CR_level_lugol(n) = multithresh(double(nonzero_CR));%use non-despeckled image
   
   l_median_img(n)=median(double(l_new));
   l_mean_img(n)=mean(double(l_new));
   l_var_img(n)=var(double(l_new));
   l_mode_img(n)=mode(double(l_new));
   l_level_lugol(n) = multithresh(double(nonzero_l));%use non-despeckled image
   
   a_median_img(n)=median(double(a_new));
   a_mean_img(n)=mean(double(a_new));
   a_var_img(n)=var(double(a_new));
   a_mode_img(n)=mode(double(a_new));
   a_level_lugol(n) = multithresh(double(nonzero_a));%use non-despeckled image
   
   b_median_img(n)=median(double(b_new));
   b_mean_img(n)=mean(double(b_new));
   b_var_img(n)=var(double(b_new));
   b_mode_img(n)=mode(double(b_new));
   b_level_lugol(n) = multithresh(double(nonzero_b));%use non-despeckled image
   
   %lesion size
   lesion_size(n)=lesionsize(dirlist(n).name);
   
%    save('features.mat','a_level_lugol','a_mean_img','a_median_img','a_mode_img','a_var_img','b_level_lugol','b_mean_img',...
%        'b_median_img','b_mode_img','b_var_img','blue_level_lugol','blue_mean_img','blue_median_img','blue_mode_img',...
%        'blue_var_img','CB_level_lugol','CB_mean_img','CB_median_img','CB_mode_img','CB_var_img','CR_level_lugol','CR_mean_img','CR_median_img',...
%        'CR_mode_img','CR_var_img','gray_level_lugol','gray_mean_img','gray_median_img','gray_mode_img','gray_var_img',...
%        'green_level_lugol','green_mean_img','green_median_img','green_mode_img','green_var_img','h_level_lugol',...
%        'h_mean_img','h_median_img','h_mode_img','h_var_img','l_level_lugol','l_mean_img','l_median_img' ,'l_mode_img',...
%        'l_var_img','red_level_lugol','red_mean_img','red_median_img','red_mode_img','red_var_img','s_level_lugol',...
%        's_mean_img','s_median_img','s_mode_img','s_var_img','v_level_lugol','v_mean_img','v_median_img','v_mode_img',...
%        'v_var_img','Y_level_lugol','Y_mean_img','Y_median_img','Y_mode_img','Y_var_img','lesion_size')
%    
   X_cervicitis(n,:)=[a_level_lugol(n),a_mean_img(n),a_median_img(n),a_mode_img(n),a_var_img(n),b_level_lugol(n),b_mean_img(n),...
       b_median_img(n),b_mode_img(n),b_var_img(n),blue_level_lugol(n),blue_mean_img(n),blue_median_img(n),blue_mode_img(n),...
       blue_var_img(n),CB_level_lugol(n),CB_mean_img(n),CB_median_img(n),CB_mode_img(n),CB_var_img(n),CR_level_lugol(n),CR_mean_img(n),CR_median_img(n),...
       CR_mode_img(n),CR_var_img(n),gray_level_lugol(n),gray_mean_img(n),gray_median_img(n),gray_mode_img(n),gray_var_img(n),...
       green_level_lugol(n),green_mean_img(n),green_median_img(n),green_mode_img(n),green_var_img(n),h_level_lugol(n),...
       h_mean_img(n),h_median_img(n),h_mode_img(n),h_var_img(n),l_level_lugol(n),l_mean_img(n),l_median_img(n),l_mode_img(n),...
       l_var_img(n),red_level_lugol(n),red_mean_img(n),red_median_img(n),red_mode_img(n),red_var_img(n),s_level_lugol(n),...
       s_mean_img(n),s_median_img(n),s_mode_img(n),s_var_img(n),v_level_lugol(n),v_mean_img(n),v_median_img(n),v_mode_img(n),...
       v_var_img(n),Y_level_lugol(n),Y_mean_img(n),Y_median_img(n),Y_mode_img(n),Y_var_img(n),lesion_size(n)];

 end  
save('features.mat','X_cervicitis')
% diagnosis