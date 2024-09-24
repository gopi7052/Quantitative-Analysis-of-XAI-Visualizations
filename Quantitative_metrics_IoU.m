% List of image names
image_names_A = {'BW_BLB1.jpg', 'BW_BLB2.jpg', 'BW_BLB3.jpg', 'BW_BLB4.jpg', 'BW_BS1.jpg', 'BW_BS2.jpg', 'BW_BS3.jpg', 'BW_BS4.jpg', 'BW_LB1.jpg', 'BW_LB2.jpg', 'BW_LB3.jpg', 'BW_LB4.jpg', 'BW_LSD1.jpg', 'BW_LSD2.jpg', 'BW_LSD3.jpg', 'BW_LSD4.jpg'};
image_names_B = {'Xception_BLB1.jpg', 'Xception_BLB2.jpg', 'Xception_BLB3.jpg', 'Xception_BLB4.jpg', 'Xception_BS1.jpg','Xception_BS2.jpg', 'Xception_BS3.jpg','Xception_BS4.jpg','Xception_LB1.jpg','Xception_LB2.jpg','Xception_LB3.jpg','Xception_LB4.jpg','Xception_LSD1.jpg','Xception_LSD2.jpg','Xception_LSD3.jpg','Xception_LSD4.jpg'};
 
% Number of folds
num_folds = 5;
 
% Initialize total values for metrics
total_iou = 0;
total_jaccard_similarity = 0;
total_dice_similarity = 0;
 
% Loop through each fold
for fold = 1:num_folds
    % Loop through each pair of images
    for i = 1:length(image_names_A)
        % Read and process image A
        path_A = fullfile('F:\Gopi (21PHD7052)\2. Journal\BW_GT\', image_names_A{i});
        A = imread(path_A);
        I1 = im2gray(A);
        BW1 = imresize(im2bw(I1, 0.1), [200, 200]);
 
        % Read and process image B
        path_B = fullfile('F:\Gopi (21PHD7052)\2. Journal\Xception_F\F12\', image_names_B{i});
        B = imread(path_B);
        I2 = im2gray(B);
        BW2 = imresize(im2bw(I2, 0.1), [200, 200]);
 
        % Calculate IoU for this pair
        intersection = BW1 & BW2;
        union = BW1 | BW2;
        iou = nnz(intersection) / nnz(union);
 
        % Calculate Jaccard Similarity for this pair
        jaccard_similarity = 1 - iou;
 
        % Calculate Dice Similarity for this pair
        dice_similarity = 2 * nnz(intersection) / (nnz(BW1) + nnz(BW2));
 
        % Accumulate values for this fold
        total_iou = total_iou + iou;
        total_jaccard_similarity = total_jaccard_similarity + jaccard_similarity;
        total_dice_similarity = total_dice_similarity + dice_similarity;
 
        % Display the pair of images
%         figure;
%         imshowpair(BW1, BW2);
%         title(['Metrics for ' image_names_A{i} ' and ' image_names_B{i}]);
%         disp(['IoU: ' num2str(iou)]);
%         disp(['Jaccard Similarity: ' num2str(jaccard_similarity)]);
%         disp(['Dice Similarity: ' num2str(dice_similarity)]);
    end
end
 
% Calculate average values for each metric
average_iou = total_iou / (num_folds * length(image_names_A));
average_jaccard_similarity = total_jaccard_similarity / (num_folds * length(image_names_A));
average_dice_similarity = total_dice_similarity / (num_folds * length(image_names_A));
 
disp(['Average IoU: ' num2str(average_iou)]);
disp(['Average Dice Similarity: ' num2str(average_dice_similarity)]);
disp(['Average Jaccard Distance: ' num2str(average_jaccard_similarity)]);
