clc,clear all
dirlist =  [dir('*.tif');dir('*.jpg')];
for n=1:length(dirlist)
    %read in data
    img_name=(dirlist(n).name);
    img = imread(img_name);
    % img=imresize(img,0.25);
    img_gray=rgb2gray(img);
%     imshow(img_gray)
    % hist_eq=histeq(img_gray);
    % r=img(:,:,1);
    % G=img(:,:,2);
    % B=img(:,:,3);
    % imshowpair(hist_eq,img_gray,'montage')
    % imshowpair(r,B,'diff')
    %%
    
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
    
    
    con=reshape(stats.Contrast,[],n_dir);%intensity contrast as a function of pixel distance shows definition and degree of texture depth
    cor=reshape(stats.Correlation,[],n_dir);%reflects similarity on a direction of image texture and is the linear correlation
    Ener=reshape(stats.Energy,[],n_dir);
    hom=reshape(stats.Homogeneity,[],n_dir);
    
    % mean_con=mean(con,2);
    % mean_cor=mean(cor,2);
    % mean_Ener=mean(Ener,2);
    % mean_hom=mean(hom,2);
    % figure;imagesc(SI)
    % all_stats=[mean_con;mean_cor;mean_Ener;mean_hom]
    
    mean_con(n)=mean(stats.Contrast);
    mean_cor(n)=mean(stats.Correlation);
    mean_Ener(n)=mean(stats.Energy);
    mean_hom(n)=mean(stats.Homogeneity);
%     figure;imagesc(SI)
    all_stats(n,:)=[mean_con(n),mean_cor(n),mean_Ener(n),mean_hom(n)];
   
    % t1=stuct2array(stats)
 end
  save('haralicks.mat','all_stats')