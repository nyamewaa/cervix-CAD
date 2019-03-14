%Code outline cervix in images
close all; clear all;
dirlist = dir('*.tif');%dir('*.tif');
% cd('S:\Nimmi\Cervix Data\Cervix Imaging - Cervix 1 Local');
for i=1:length(dirlist)
    %read in data
    img = imread(dirlist(i).name);  
%% Have to put in these variables before running
folder = '/Users/usamahchaudhary/Documents/TOpS/TOpS Cervix Images/Pocket/'; %Folder where the image is saved
% image =['L',num2str(i)]; %Image name
filename=dirlist(i).name;%['C:\Users\mna14\Desktop\acetowhitening margin\Peru Lugol\Lugol\normal_all_brown\',image];

%%
I = imread(filename);
I=I(:,:,1:3);
%Trace outline of cervix
figure, imshow(I);
hold on;
for nnn = 1:1:NumLesions
h = imfreehand;
LesionTemp = createMask(h);
eval(['Lesion' num2str(nnn) '= LesionTemp;']); 

end
hold off; 

AllLesionsMask = Lesion1; 
    
I2 = im2double(I);

%% LesionMask

%If you didn't outline it perfectly, this gets rid of the little extra
%parts or bumps of the outline
CCtemp = bwconncomp(AllLesionsMask);
d1 = regionprops(CCtemp,'Area');
celld1 = struct2cell(d1);
matd1 = cell2mat(celld1);
areaTH = matd1; 

idx = find(areaTH<=100);
AllLesionsMask1 = AllLesionsMask;
for ttt = 1:1:length(idx)
    idx_temp = idx(ttt); 
    AllLesionsMask1(CCtemp.PixelIdxList{idx_temp}) = 0; 
end

%This finds the center of each lesion and the boundaries
LesionMaskLabels = bwlabel(AllLesionsMask1); 
blobMeasurements1 = regionprops(LesionMaskLabels,'Centroid'); 

[B,L] = bwboundaries(AllLesionsMask1);
% save([folder 'cervix_mask\' image '_cervix'],'AllLesionsMask1');
 save([folder 'cervix_mask\' filename '.mat'],'AllLesionsMask1');
% saveas(gcf,[folder 'cervix_outline\' filename])
%% Plot all lesions

fontSize = 10;	
labelShiftX = 35;

%This draws the boundaries and numbers each nucleus to the right of the
%centroid
figure; imshow(I2);
hold on;
for k = 1:NumLesions
    boundary1 = B{k};
    plot(boundary1(:,2), boundary1(:,1), 'g', 'LineWidth', 2)
    blobCentroid1 = blobMeasurements1(k).Centroid;
    
    %text(blobCentroid(1) + labelShiftX, blobCentroid(2), num2str(k), 'Color', 'w', 'FontSize', fontSize, 'FontWeight', 'Bold');
end
hold off; 

% save('AllLesionsMask1',[folder 'cervix_mask\' image '_cervix']);
saveas(gcf,[folder 'cervix_outline\' filename])
end
% %% Stats for all Lesion
% 
% %This code calculates all of the statistics for each lesion
% LesionStats = zeros(NumLesion,2); 
% 
% %This finds the center of each lesion and the boundaries
% LesionMaskLabels = bwlabel(AllLesionMask1); 
% CCTemp = bwconncomp(LesionMaskLabels); 
% 
% %Calculates the major axis of each lesion
% MajorAxisTemp = regionprops(CCTemp,'MajorAxisLength'); 
% CellTemp = struct2cell(MajorAxisTemp);
% MatTemp = cell2mat(CellTemp);
% LesionStats(1:NumLesion,1) = MatTemp; 
% 
% %Calculates the minor axis of each lesion
% MinorAxisTemp = regionprops(CCTemp,'MinorAxisLength'); 
% CellTemp = struct2cell(MinorAxisTemp);
% MatTemp = cell2mat(CellTemp);
% LesionStats(1:NumLesion,2) = MatTemp; 
% 
% LesionStats = LesionStats.*0.293
% 
% save(filename, 'AllLesionMask1','LesionStats','I');
% %xlswrite('LesionStatsMuscle1',LesionStats); 
% 
