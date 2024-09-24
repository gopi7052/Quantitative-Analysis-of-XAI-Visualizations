% List of image names
image_names_A = {'BW_BLB1.jpg', 'BW_BLB2.jpg', 'BW_BLB3.jpg', 'BW_BLB4.jpg', 'BW_BS1.jpg', 'BW_BS2.jpg', 'BW_BS3.jpg', 'BW_BS4.jpg', 'BW_LB1.jpg', 'BW_LB2.jpg', 'BW_LB3.jpg', 'BW_LB4.jpg', 'BW_LSD1.jpg', 'BW_LSD2.jpg', 'BW_LSD3.jpg', 'BW_LSD4.jpg'};
image_names_B = {'Xception_BLB1.jpg', 'Xception_BLB2.jpg', 'Xception_BLB3.jpg', 'Xception_BLB4.jpg', 'Xception_BS1.jpg','Xception_BS2.jpg', 'Xception_BS3.jpg','Xception_BS4.jpg','Xception_LB1.jpg','Xception_LB2.jpg','Xception_LB3.jpg','Xception_LB4.jpg','Xception_LSD1.jpg','Xception_LSD2.jpg','Xception_LSD3.jpg','Xception_LSD4.jpg'};
 
% Number of folds
num_folds = 5;
 
% Initialize total values for metrics
total_sensitivity = 0;
total_specificity = 0;
total_precision = 0;
total_f1_score = 0;
total_mcc = 0;
 
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
 
        % Calculate true positives, false positives, true negatives, false negatives
        truePositives = nnz(BW1 & BW2);
        falsePositives = nnz(~BW1 & BW2);
        trueNegatives = nnz(~BW1 & ~BW2);
        falseNegatives = nnz(BW1 & ~BW2);
 
        % Calculate Sensitivity (Recall)
        sensitivity = truePositives / (truePositives + falseNegatives);
 
        % Calculate Specificity
        specificity = trueNegatives / (trueNegatives + falsePositives);
 
        % Calculate Precision
        precision = truePositives / (truePositives + falsePositives);
 
        % Calculate F1 Score
        f1_score = 2 * (precision * sensitivity) / (precision + sensitivity);
 
        % Calculate Matthew's Correlation Coefficient (MCC)
        mcc = (truePositives * trueNegatives - falsePositives * falseNegatives) / sqrt((truePositives + falsePositives) * (truePositives + falseNegatives) * (trueNegatives + falsePositives) * (trueNegatives + falseNegatives));
 
        % Accumulate values for this fold
        total_sensitivity = total_sensitivity + sensitivity;
        total_specificity = total_specificity + specificity;
        total_precision = total_precision + precision;
        total_f1_score = total_f1_score + f1_score;
        total_mcc = total_mcc + mcc;
 
        % Display the pair of images
%         figure;
%         imshowpair(BW1, BW2);
%         title(['Metrics for ' image_names_A{i} ' and ' image_names_B{i}]);
%         disp(['Sensitivity: ' num2str(sensitivity)]);
%         disp(['Specificity: ' num2str(specificity)]);
%         disp(['Precision: ' num2str(precision)]);
%         disp(['F1 Score: ' num2str(f1_score)]);
%         disp(['MCC: ' num2str(mcc)]);
    end
end
 
% Calculate average values for each metric
average_sensitivity = total_sensitivity / (num_folds * length(image_names_A));
average_specificity = total_specificity / (num_folds * length(image_names_A));
average_precision = total_precision / (num_folds * length(image_names_A));
average_f1_score = total_f1_score / (num_folds * length(image_names_A));
average_mcc = total_mcc / (num_folds * length(image_names_A));
 
disp(['Average Precision: ' num2str(average_precision)]);
disp(['Average Sensitivity(Recall): ' num2str(average_sensitivity)]);
disp(['Average Specificity: ' num2str(average_specificity)]);
disp(['Average F1 Score: ' num2str(average_f1_score)]);
disp(['Average MCC: ' num2str(average_mcc)]);
