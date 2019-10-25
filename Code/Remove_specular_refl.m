function [spec_rfl_removed] = Remove_specular_refl(image)
% clc; % Clear the command window.
% close all; % Close all figures (except those of imtool.)
% imtool close all; % Close all imtool figures.
% clear; % Erase all existing variables.
% workspace; % Make sure the workspace panel is showing.
fontSize = 14;

% Change the current folder to the folder of this m-file.
% tic;
rgbImage = image;
% Get the dimensions of the image. numberOfColorBands should be = 3.
[rows columns numberOfColorBands] = size(rgbImage);
% Display the original color image.

drawnow;
redPlane = rgbImage(:, :, 1);
greenPlane = rgbImage(:, :, 2);
bluePlane = rgbImage(:, :, 3);

% Find the white areas.
binaryImage = redPlane > 220& greenPlane > 220 & bluePlane > 220;

% Dilate it
dilationWindowSize = 20;
dilatedImage = imdilate(binaryImage, ones(dilationWindowSize,dilationWindowSize));
caption = sprintf('Dilated Binary Image\nwith outlines');

% bwboundaries() returns a cell array, where each cell contains therow/column coordinates for an object in the image.
% Plot the borders of all the coins on the original grayscale image using the coordinates returned by bwboundaries.
boundaries = bwboundaries(dilatedImage);
numberOfBoundaries = size(boundaries);
% Initialize filled in images.
newRed = redPlane;
newGreen = greenPlane;
newBlue = bluePlane;
for k = 1 : numberOfBoundaries
%     fprintf(1, 'Processing Boundary #%d...\n', k);
thisBoundary = boundaries{k};
    xCoordinates = thisBoundary(:,2);
    yCoordinates = thisBoundary(:,1);
    
    % For each boundary, fill in the area on each color plane.
    newRed = roifill(newRed, xCoordinates, yCoordinates);
    newGreen = roifill(newGreen, xCoordinates, yCoordinates);
    newBlue = roifill(newBlue, xCoordinates, yCoordinates);
end

% Create the output image
newRGBImage = cat(3, newRed, newGreen, newBlue);
spec_rfl_removed=newRGBImage;
% for k = 1 : numberOfBoundaries
% thisBoundary = boundaries{k};
% xCoordinates = thisBoundary(:,2);
% yCoordinates = thisBoundary(:,1);
% plot(xCoordinates, yCoordinates, 'g', 'LineWidth', 2);
% end
% s=toc; % Stop timer
% caption = sprintf('Done!\nElapsed time = %.1f seconds.', s);
% msgbox (caption);