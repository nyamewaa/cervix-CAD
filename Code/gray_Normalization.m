function Norm_image = gray_Normalization(grayImage);
originalMinValue = double(min(min(grayImage)));
originalMaxValue = double(max(max(grayImage)));
originalRange = originalMaxValue - originalMinValue;

% Get a double image in the range 0 to +1
desiredMin = 0;
desiredMax = 1;
desiredRange = desiredMax - desiredMin;
Norm_image = desiredRange * (double(grayImage) - originalMinValue) /originalRange + desiredMin;