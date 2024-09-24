net = Trained_Network;
X = imread("F:\Gopi (21PHD7052)\2. Journal\GT\LSD\LSD4.jpg");
inputSize = net.Layers(1).InputSize(1:2);
X = imresize(X, inputSize);
 
% Classify the image
label = classify(net, X);
 
% Generate LIME explanations
[scoreMap, featureMap, featureImportance] = imageLIME(net, X, label, 'Segmentation', 'grid', 'NumFeatures', 64, 'NumSamples', 3072);
 
% Different values of numTopFeatures
numTopFeatures_values = [6, 8, 10, 12];
 
% Specify the path for saving figures
savePath = 'F:\Gopi (21PHD7052)\2. Journal\EfficientNetB0\LSD\';
 
% Iterate over each value of numTopFeatures
for i = 1:length(numTopFeatures_values)
    numTopFeatures = numTopFeatures_values(i);
 
    % Display the original image with explanations
    figure;
    imshow(X);
    hold on;
    imagesc(scoreMap, 'AlphaData', 0.5);
    colormap jet;
    colorbar;
 
    % Save the figure
    figName = sprintf('%sEfficientNetB0_LSD4_%dGD.pdf', savePath, numTopFeatures);
    saveas(gcf, figName);
 
    % Display the masked image for the top features
    [~, idx] = maxk(featureImportance, numTopFeatures);
    mask = ismember(featureMap, idx);
    maskedImg = uint8(mask) .* X;
 
    % Display the masked image
     figure;
     imshow(maskedImg);
     title(['Top ', num2str(numTopFeatures), ' features']);
 
    % Save the second figure
    figName = sprintf('%sEfficientNetB0_LSD4_F%d.pdf', savePath, numTopFeatures);
    saveas(gcf, figName);
end

