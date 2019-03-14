function [texture]=haralick_feature_fun(image)
    %read in data
    img = image;
    % img=imresize(img,0.25);
    img_gray=rgb2gray(img);
    
    %read and display input image
    n_dir=4;
    offset=[0 1;0 5;0 10;0 15;...
        -1 1; -5 5;-10 10;-15 15;...
        -1 0;-5 0;-10 0;-15 0;...
        -1 -1;-5 -5;-10 -10;-15 -15;];% offset of four directions
    %and 4 distances for each direction. i.e [D,0],[-D,D],[-D,0],[-D,-D];
    [glcms, SI]=graycomatrix(img_gray,'NumLevels',256,'Offset',offset);% Returns glcm and scaled
    %image used to calculate glcm
    stats=graycoprops(glcms);
    
%     
%     con=reshape(stats.Contrast,[],n_dir);%intensity contrast as a function of pixel distance shows definition and degree of texture depth
%     cor=reshape(stats.Correlation,[],n_dir);%reflects similarity on a direction of image texture and is the linear correlation
%     Ener=reshape(stats.Energy,[],n_dir);
%     hom=reshape(stats.Homogeneity,[],n_dir);
%   
%    
    mean_con=mean(stats.Contrast);
    mean_cor=mean(stats.Correlation);
    mean_Ener=mean(stats.Energy);
    mean_hom=mean(stats.Homogeneity);

    texture=[mean_con,mean_cor,mean_Ener,mean_hom];
 end
