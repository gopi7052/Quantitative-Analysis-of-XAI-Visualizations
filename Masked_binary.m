% Define the folder path containing the images
folderPath = 'F:\Gopi (21PHD7052)\2. Journal\InceptionResNetV2_F\F12\';
 
% Specify the folder for saving binary images as PDFs
saveFolderPath = 'F:\Gopi (21PHD7052)\2. Journal\InceptionResNetV2_F\F12\BinaryImagesF12\';
 
% Create the folder if it doesn't exist
if ~exist(saveFolderPath, 'dir')
    mkdir(saveFolderPath);
end
 
% Get a list of all JPEG files in the folder
jpegFiles = dir(fullfile(folderPath, '*.jpg'));
 
% Loop through each image
for i = 1:numel(jpegFiles)
    % Construct the full file path
    imagePath = fullfile(folderPath, jpegFiles(i).name);
 
    % Read the image
    B = imread(imagePath);
    I2 = im2gray(B);
 
    % Resize and convert to binary
    BW2 = imresize(im2bw(I2, 0.1), [200, 200]);
 
    % Specify the file name for the binary image in PDF format
    binaryImageName = fullfile(saveFolderPath, ['BW_' jpegFiles(i).name(1:end-4) '.pdf']);
 
    % Create a new figure for the binary image
    figure;
    imshow(BW2);
    title(['Binary ' jpegFiles(i).name]);
 
    % Save the figure as a PDF
    exportgraphics(gcf, binaryImageName, 'ContentType', 'vector');
    close(gcf); % Close the figure to avoid displaying multiple figures
end

