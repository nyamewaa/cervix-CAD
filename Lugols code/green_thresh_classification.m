% clc,clear all
% folder='C:\Users\mna14\Desktop\Research\Lugols image processing\Revised_code_all_images\La Liga\best performing physician(John)\Positive\';
% dirlist = dir('*.tif');
% for n=1:length(dirlist)
%     %read in data
%     name(n)={dirlist(n).name};
%     img_name=(dirlist(n).name);
    cervix_crop=imread('L99.tif');
    blue_img = cervix_crop(:, :, 3);
    despec_index=find(blue_img(:) < 240);
    
    %find corresponding despeckled areas in green channel
    green_img=cervix_crop(:,:,3);%rgb2gray(img);%
    green_list=green_img(:);
%     despec_ind=find(green_img<240);
%     green_despec=green_list(despec_ind);
    
    % find areas not equal to 0
    green_img_ind=find(green_list>0);
    nonzero_green=green_list(green_img_ind);
    
    % find stats
    level_lugol = multithresh(nonzero_green);
    %%
    %classify based on threshold
    if level_lugol(n)>=116;
        diag(n)={'Normal'};
        seg(n)=0;
    elseif level_lugol(n)<116;
        diag(n)={'Abnormal'};
        %show threshold image
        cform= makecform('srgb2lab');
        lab = applycform(cervix_crop,cform);
        a=lab(:,:,2);
        b=lab(:,:,3);
        
        
        level_lugol2 = multithresh(b,6);
        seg=level_lugol;
        lugol_seg = imquantize(green_img,level_lugol);
        lugol_seg(lugol_seg==1)=0;
        lugol_seg(lugol_seg==2)=1;
        lugol_seg=logical(lugol_seg);
        figure; imshow(cervix_crop, 'InitialMag', 'fit')
        green = cat(3, zeros(size(green_img)),ones(size(green_img)), zeros(size(green_img)));
        hold on
        h = imshow(green);
        hold off
        set(h, 'AlphaData', lugol_seg)
        saveas(gcf,[folder 'lesion\' img_name])
        close all
    end
    thresh_features(n,:)=[name(n),level_lugol(n),seg(n),diag(n)];
    clear seg
    clear level_lugol2
% end
save('thresh_features.mat','thresh_features')
