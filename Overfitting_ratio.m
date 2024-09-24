% Define target and identified ROIs
target_roi = imread('F:\Gopi (21PHD7052)\2. Journal\BW_Models\Overfit\LSD4.jpg');
identified_roi = imread('F:\Gopi (21PHD7052)\2. Journal\BW_Models\EfficientNetB0\F12\LSD4.jpg');
 
% Resize images to a common size (e.g., 200x200)
target_roi = imresize(target_roi, [200, 200]);
identified_roi = imresize(identified_roi, [200, 200]);
 
% Ensure both images have the same dimensions
if ~isequal(size(target_roi), size(identified_roi))
    error('Target and identified ROIs must have the same dimensions.');
end
 
% Extract pixel information
target_pixels = target_roi(:) ~= 0; % Convert image to vector and identify non-zero pixels (target class)
identified_pixels = identified_roi(:) ~= 0; % Same for identified ROI
 
% Calculate area of each ROI
target_area = sum(target_pixels);
identified_area = sum(identified_pixels);
 
% Calculate TP, FP, TN, and FN
TP = sum(target_pixels & identified_pixels);
FP = sum(~target_pixels & identified_pixels);
TN = sum(~target_pixels & ~identified_pixels);
FN = sum(target_pixels & ~identified_pixels);
 
% Calculate overfitting ratio
overfitting_ratio = (identified_area - target_area) / target_area;
 
% Calculate normalized area outside ROI
normalized_area_outside_roi = FP / (numel(identified_roi) - identified_area);
 
% Display results
fprintf('TP: %d, FP: %d, TN: %d, FN: %d\n', TP, FP, TN, FN);
fprintf('Overfitting Ratio: %f\n', overfitting_ratio);
fprintf('Normalized Area Outside ROI: %f\n', normalized_area_outside_roi);
 
