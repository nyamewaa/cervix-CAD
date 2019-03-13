clc; % Clear the command window.
close all; % Close all figures (except those of imtool.)
imtool close all; % Close all imtool figures.
clear; % Erase all existing variables.
workspace; % Make sure the workspace panel is showing.
fontSize = 14;
%%
% Change the current folder to the folder of this m-file.

% cd('C:\Users\mna14\Desktop\acetowhitening margin');
figure;
tic; % Start timer
% Read in a standard MATLAB color demo image.
folder = 'X:\Mercy\Image processing\VIA image processing\Peru\images\used for spec reflection';
%folder = 'C:\Users\mna14\Desktop\Research\Cevix Image processing\Images\Peru\Peru Lugol\Lugol\normal\train112016\Interpretable data';
baseFileName = 'W27.tif';
fullFileName = fullfile(folder, baseFileName);
rgbImage = imread(fullFileName);

% Get the dimensions of the image. numberOfColorBands should be = 3.
[rows columns numberOfColorBands] = size(rgbImage);
% Display the original color image.
subplot(2, 4, 1);
imshow(rgbImage, []);
title('Original color Image', 'FontSize', fontSize);
set(gcf, 'Position', get(0,'Screensize')); % Enlarge figure to fullscreen.
drawnow;
redPlane = rgbImage(:, :, 1);
greenPlane = rgbImage(:, :, 2);
bluePlane = rgbImage(:, :, 3);
subplot(2, 4, 2);
imshow(redPlane, []);
title('Red Channel', 'FontSize', fontSize);
subplot(2, 4, 3);
imshow(greenPlane, []);
title('Green Channel', 'FontSize', fontSize);
subplot(2, 4, 4);
imshow(bluePlane, []);
title('Blue Channel', 'FontSize', fontSize);

% Find the white areas.
binaryImage =  redPlane > 220 & greenPlane > 220 & bluePlane > 220;
%binaryImage =   bluePlane > 220;
subplot(2, 4, 5);
imshow(binaryImage, []);
title('Binary Image', 'FontSize', fontSize);

% Dilate it
dilationWindowSize = 15;
dilatedImage = imdilate(binaryImage, ones(dilationWindowSize,dilationWindowSize));
subplot(2, 4, 6);
imshow(dilatedImage, []);
caption = sprintf('Dilated Binary Image\nwith outlines');
title(caption, 'FontSize', fontSize);

% bwboundaries() returns a cell array, where each cell contains therow/column coordinates for an object in the image.
% Plot the borders of all the coins on the original grayscale image using the coordinates returned by bwboundaries.
hold on;
boundaries = bwboundaries(dilatedImage);
numberOfBoundaries = size(boundaries);
% Initialize filled in images.
newRed = redPlane;
newGreen = greenPlane;
newBlue = bluePlane;
for k = 1 : numberOfBoundaries
    fprintf(1, 'Processing Boundary #%d...\n', k);
thisBoundary = boundaries{k};
    xCoordinates = thisBoundary(:,2);
    yCoordinates = thisBoundary(:,1);
    subplot(2, 4, 6);
plot(xCoordinates, yCoordinates, 'g', 'LineWidth', 2);
    % For each boundary, fill in the area on each color plane.
    newRed = roifill(newRed, xCoordinates, yCoordinates);
    newGreen = roifill(newGreen, xCoordinates, yCoordinates);
    newBlue = roifill(newBlue, xCoordinates, yCoordinates);
end
hold off;

% Create the output image
newRGBImage = cat(3, newRed, newGreen, newBlue);
spec_rfl_removed=newRGBImage;
subplot(2, 4, 7);
imshow(newRGBImage, []);
hold on;
caption = sprintf('Final RGB image with\nspecular reflections removed');
title(caption, 'FontSize', fontSize);
%  for k = 1 : numberOfBoundaries
%  thisBoundary = boundaries{k};
%  xCoordinates = thisBoundary(:,2);
%  yCoordinates = thisBoundary(:,1);
%  plot(xCoordinates, yCoordinates, 'g', 'LineWidth', 2);
%  end
s=toc; % Stop timer
caption = sprintf('Done!\nElapsed time = %.1f seconds.', s);
msgbox (caption);