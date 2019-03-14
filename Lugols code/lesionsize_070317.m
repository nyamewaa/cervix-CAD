
imdata=imread('L173.tif');
% Reading channels
BC = imdata(:,:,3);
bw=BC<220;
img=uint8(double(imdata).* double(repmat(bw, [1 1 3])));
imshow(img)
RC = img(:,:,1);
GC = img(:,:,2);
BC2 = img(:,:,3);
%%
yellow_ind3=(RC>=200) & (GC>=100) & (BC2>=10);
%yellow_ind3=(RC>=230)& (BC<=130)& GC>=120;%& (GC<=180);%&(150<=GC<=200) & (BC<=220);
lesion_img=uint8(double(imdata).* double(repmat(yellow_ind3, [1 1 3])));
find(lesion_img);
figure
imshow(imdata, 'InitialMag', 'fit')
 red= cat(3, ones(size(imdata(:,:,1))), zeros(size(imdata(:,:,1))), zeros(size(imdata(:,:,1))));
 hold on
 h = imshow(red);
 hold off
 set(h, 'AlphaData',yellow_ind3)
%% VILI
figure;
cform= makecform('srgb2lab');
lab = applycform(img,cform);
a=lab(:,:,2);
b=lab(:,:,3);
imagesc(b),colormap(jet);colorbar;%caxis([0 60])
%%
level_lugol2 = multithresh(b,6);
seg=imquantize(b,level_lugol2);
lugol_seg = imquantize(b,level_lugol2([5:6]));
lugol_seg(lugol_seg==1)=0;
lugol_seg(lugol_seg==2)=1;
lugol_seg=logical(lugol_seg);
imshow(imdata, 'InitialMag', 'fit')
green = cat(3, zeros(size(b)),ones(size(b)), zeros(size(b)));
hold on
h = imshow(green);
hold off
set(h, 'AlphaData', lugol_seg)
 
 
 %% Calculate size
lesion_ind=find(lesion_img);
lesion_size=size(lesion_ind,1);
cervix_ind=find(imdata);
cervix_size=size(cervix_ind,1);
lesion_percent=(lesion_size/cervix_size)

