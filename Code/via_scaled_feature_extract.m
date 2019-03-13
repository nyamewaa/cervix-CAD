    %read in data
    function []=color_feat_extract (image)
    img = imread(image);      
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
   
  %% writevout as lists
  red_list=red(:);
  green_list=green(:);
  blue_list=blue(:);
  gray_list=gray(:); 
  h_list=h(:); 
  s_list=s(:); 
  v_list=v(:);
  Y_list=Y(:);
  CB_list=CB(:);  
  CR_list=CR(:);
  l_list=l(:);
  a_list=a(:);
  b_list=b(:);
    
  %% Dezero
  img_ind=find(green_list>0);
  nonzero_red=red_list(img_ind);
  nonzero_green=green_list(img_ind);
  nonzero_blue=blue_list(img_ind);
  nonzero_gray=gray_list(img_ind);
  nonzero_h=h_list(img_ind);
  nonzero_s=s_list(img_ind);
  nonzero_v=v_list(img_ind);
  nonzero_Y=Y_list(img_ind);
  nonzero_CB=CB_list(img_ind);
  nonzero_CR=CR_list(img_ind);
  nonzero_l=l_list(img_ind);
  nonzero_a=a_list(img_ind);
  nonzero_b=b_list(img_ind);

  %% find stats
  red_median_img(n)=median(double(nonzero_red));
  red_mean_img(n)=mean(double(nonzero_red));
  red_var_img(n)=var(double(nonzero_red));
  red_mode_img(n)=mode(double(nonzero_red));
  red_level_lugol(n) = multithresh(double(nonzero_red));%use non-despeckled image
  
  green_median_img(n)=median(double(nonzero_green));
  green_mean_img(n)=mean(double(nonzero_green));
  green_var_img(n)=var(double(nonzero_green));
  green_mode_img(n)=mode(double(nonzero_green));
  green_level_lugol(n) = multithresh(double(nonzero_green));%use non-despeckled image
  
  blue_median_img(n)=median(double(nonzero_blue));
  blue_mean_img(n)=mean(double(nonzero_blue));
  blue_var_img(n)=var(double(nonzero_blue));
  blue_mode_img(n)=mode(double(nonzero_blue));
  blue_level_lugol(n) = multithresh(double(nonzero_blue));%use non-despeckled image
  
  gray_median_img(n)=median(double(nonzero_gray));
  gray_mean_img(n)=mean(double(nonzero_gray));
  gray_var_img(n)=var(double(nonzero_gray));
  gray_mode_img(n)=mode(double(nonzero_gray));
  gray_level_lugol(n) = multithresh(double(nonzero_gray));%use non-despeckled image
  
  h_median_img(n)=median(double(nonzero_h));
  h_mean_img(n)=mean(double(nonzero_h));
  h_var_img(n)=var(double(nonzero_h));
  h_mode_img(n)=mode(double(nonzero_h));
  h_level_lugol(n) = multithresh(double(nonzero_h));%use non-despeckled image
  
   s_median_img(n)=median(double(nonzero_s));
   s_mean_img(n)=mean(double(nonzero_s));
   s_var_img(n)=var(double(nonzero_s));
   s_mode_img(n)=mode(double(nonzero_s));
   s_level_lugol(n) = multithresh(double(nonzero_s));%use non-despeckled image
   
   v_median_img(n)=median(double(nonzero_v));
   v_mean_img(n)=mean(double(nonzero_v));
   v_var_img(n)=var(double(nonzero_v));
   v_mode_img(n)=mode(double(nonzero_v));
   v_level_lugol(n) = multithresh(double(nonzero_v));%use non-despeckled image
   
   Y_median_img(n)=median(double(nonzero_Y));
   Y_mean_img(n)=mean(double(nonzero_Y));
   Y_var_img(n)=var(double(nonzero_Y));
   Y_mode_img(n)=mode(double(nonzero_Y));
   Y_level_lugol(n) = multithresh(double(nonzero_Y));%use non-despeckled image
   
   CB_median_img(n)=median(double(nonzero_CB));
   CB_mean_img(n)=mean(double(nonzero_CB));
   CB_var_img(n)=var(double(nonzero_CB));
   CB_mode_img(n)=mode(double(nonzero_CB));
   CB_level_lugol(n) = multithresh(double(nonzero_CB));%use non-despeckled image
   
   CR_median_img(n)=median(double(nonzero_CR));
   CR_mean_img(n)=mean(double(nonzero_CR));
   CR_var_img(n)=var(double(nonzero_CR));
   CR_mode_img(n)=mode(double(nonzero_CR));
   CR_level_lugol(n) = multithresh(double(nonzero_CR));%use non-despeckled image
   
   l_median_img(n)=median(double(nonzero_l));
   l_mean_img(n)=mean(double(nonzero_l));
   l_var_img(n)=var(double(nonzero_l));
   l_mode_img(n)=mode(double(nonzero_l));
   l_level_lugol(n) = multithresh(double(nonzero_l));%use non-despeckled image
   
   a_median_img(n)=median(double(nonzero_a));
   a_mean_img(n)=mean(double(nonzero_a));
   a_var_img(n)=var(double(nonzero_a));
   a_mode_img(n)=mode(double(nonzero_a));
   a_level_lugol(n) = multithresh(double(nonzero_a));%use non-despeckled image
   
   b_median_img(n)=median(double(nonzero_b));
   b_mean_img(n)=mean(double(nonzero_b));
   b_var_img(n)=var(double(nonzero_b));
   b_mode_img(n)=mode(double(nonzero_b));
   b_level_lugol(n) = multithresh(double(nonzero_b));%use non-despeckled image
   
   %lesion size
   
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
   color_features(n,:)=[a_level_lugol(n),a_mean_img(n),a_median_img(n),a_mode_img(n),a_var_img(n),b_level_lugol(n),b_mean_img(n),...
       b_median_img(n),b_mode_img(n),b_var_img(n),blue_level_lugol(n),blue_mean_img(n),blue_median_img(n),blue_mode_img(n),...
       blue_var_img(n),CB_level_lugol(n),CB_mean_img(n),CB_median_img(n),CB_mode_img(n),CB_var_img(n),CR_level_lugol(n),CR_mean_img(n),CR_median_img(n),...
       CR_mode_img(n),CR_var_img(n),gray_level_lugol(n),gray_mean_img(n),gray_median_img(n),gray_mode_img(n),gray_var_img(n),...
       green_level_lugol(n),green_mean_img(n),green_median_img(n),green_mode_img(n),green_var_img(n),h_level_lugol(n),...
       h_mean_img(n),h_median_img(n),h_mode_img(n),h_var_img(n),l_level_lugol(n),l_mean_img(n),l_median_img(n),l_mode_img(n),...
       l_var_img(n),red_level_lugol(n),red_mean_img(n),red_median_img(n),red_mode_img(n),red_var_img(n),s_level_lugol(n),...
       s_mean_img(n),s_median_img(n),s_mode_img(n),s_var_img(n),v_level_lugol(n),v_mean_img(n),v_median_img(n),v_mode_img(n),...
       v_var_img(n),Y_level_lugol(n),Y_mean_img(n),Y_median_img(n),Y_mode_img(n),Y_var_img(n)];

 end  
save('color_features.mat','color_features')
% diagnosis