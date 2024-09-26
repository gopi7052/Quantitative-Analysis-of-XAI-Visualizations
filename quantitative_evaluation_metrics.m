function Quantitative_evaluation_metrics
    % Create a figure for the UI
     hFig = figure('Position', [100, 100, 600, 700], 'MenuBar', 'none', ...
                   'Name', 'XAI Quantitative Analysis', 'NumberTitle', 'off', ...
                   'Resize', 'on');
%        % Create the main UI figure in full screen
%     hfig = uifigure('Name', 'XAI Quantitative Analysis', 'WindowState', 'maximized');
%     movegui(hfig, 'center');        

    % Create title text field
    uicontrol('Style', 'text', 'Position', [20, 650, 560, 30], ...
              'String', 'Quantitative Analysis', 'FontSize', 14, ...
              'HorizontalAlignment', 'center', ...
              'ForegroundColor', 'red');

    % Button for selecting ground truth image
    uicontrol('Style', 'pushbutton', 'String', 'Select Ground Truth Image', 'FontSize', 10,...
              'Position', [30, 600, 250, 35], 'Callback', @select_image_a);
          
    % Button for selecting masked n features image
    uicontrol('Style', 'pushbutton', 'String', 'Masked n Feature Image', 'FontSize', 10,...
              'Position', [320, 600, 250, 35], 'Callback', @select_image_b);

    % Create axes for displaying images with proper spacing
    handles.ax1 = axes('Position', [0.1, 0.55, 0.35, 0.35]); % Left Image
    handles.ax2 = axes('Position', [0.55, 0.55, 0.35, 0.35]); % Right Image

    % Button for calculating metrics below the images
    uicontrol('Style', 'pushbutton', 'String', 'Calculate', 'FontSize', 11,...
              'Position', [225, 260, 150, 40], 'Callback', @calculate_metrics);

    % Placeholder for selected image paths
    handles.imageA = '';
    handles.imageB = '';

    guidata(hFig, handles); % Save the handles structure

    % Create a panel for displaying metrics below the calculate button
    metricsPanel = uipanel('Title', 'Metrics', 'FontSize', 10, 'Position', [0.1, 0.05, 0.8, 0.30]);

    % Create text fields for displaying metrics
    handles.iouText = uicontrol(metricsPanel, 'Style', 'text', 'Position', [10, 100, 250, 20], ...
                                 'String', 'IoU: ', 'FontSize', 10);
    handles.jaccardText = uicontrol(metricsPanel, 'Style', 'text', 'Position', [10, 80, 250, 20], ...
                                     'String', 'Jaccard Similarity: ', 'FontSize', 10);
    handles.diceText = uicontrol(metricsPanel, 'Style', 'text', 'Position', [10, 60, 250, 20], ...
                                  'String', 'Dice Similarity: ', 'FontSize', 10);
    handles.sensitivityText = uicontrol(metricsPanel, 'Style', 'text', 'Position', [10, 40, 250, 20], ...
                                         'String', 'Sensitivity: ', 'FontSize', 10);
    handles.specificityText = uicontrol(metricsPanel, 'Style', 'text', 'Position', [10, 20, 250, 20], ...
                                         'String', 'Specificity: ', 'FontSize', 10);
    handles.precisionText = uicontrol(metricsPanel, 'Style', 'text', 'Position', [300, 100, 250, 20], ...
                                       'String', 'Precision: ', 'FontSize', 10);
    handles.f1Text = uicontrol(metricsPanel, 'Style', 'text', 'Position', [300, 80, 250, 20], ...
                                'String', 'F1 Score: ', 'FontSize', 10);
    handles.mccText = uicontrol(metricsPanel, 'Style', 'text', 'Position', [300, 60, 250, 20], ...
                                 'String', 'MCC: ', 'FontSize', 10);

    guidata(hFig, handles); % Update handles

    function select_image_a(~, ~)
        [fileA, pathA] = uigetfile({'*.jpg;*.png;*.tif', 'Image Files (*.jpg, *.png, *.tif)'}, 'Select Ground Truth Image');
        if isequal(fileA, 0)
            return; % User cancelled
        end
        handles = guidata(hFig);
        handles.imageA = fullfile(pathA, fileA);
        guidata(hFig, handles);
        imshow(handles.imageA, 'Parent', handles.ax1);
    end

    function select_image_b(~, ~)
        [fileB, pathB] = uigetfile({'*.jpg;*.png;*.tif', 'Image Files (*.jpg, *.png, *.tif)'}, 'Select Masked n Features');
        if isequal(fileB, 0)
            return; % User cancelled
        end
        handles = guidata(hFig);
        handles.imageB = fullfile(pathB, fileB);
        guidata(hFig, handles);
        imshow(handles.imageB, 'Parent', handles.ax2);
    end

    function calculate_metrics(~, ~)
        handles = guidata(hFig);
        
        if isempty(handles.imageA) || isempty(handles.imageB)
            errordlg('Please select both images.', 'Image Selection Error');
            return;
        end
        
        % Read and process image A
        A = imread(handles.imageA);
        I1 = im2gray(A);
        BW1 = imresize(im2bw(I1, 0.1), [200, 200]);

        % Read and process image B
        B = imread(handles.imageB);
        I2 = im2gray(B);
        BW2 = imresize(im2bw(I2, 0.1), [200, 200]);

        % Calculate true positives, false positives, true negatives, false negatives
        truePositives = nnz(BW1 & BW2);
        falsePositives = nnz(~BW1 & BW2);
        trueNegatives = nnz(~BW1 & ~BW2);
        falseNegatives = nnz(BW1 & ~BW2);

        % Calculate IoU
        intersection = BW1 & BW2;
        union = BW1 | BW2;
        iou = nnz(intersection) / nnz(union);

        % Calculate Jaccard Similarity
        jaccard_similarity = nnz(intersection) / nnz(union);

        % Calculate Dice Similarity
        dice_similarity = 2 * nnz(intersection) / (nnz(BW1) + nnz(BW2));
        
        % Calculate Sensitivity (Recall)
        sensitivity = truePositives / (truePositives + falseNegatives);

        % Calculate Specificity
        specificity = trueNegatives / (trueNegatives + falsePositives);

        % Calculate Precision
        precision = truePositives / (truePositives + falsePositives);

        % Calculate F1 Score
        f1_score = 2 * (precision * sensitivity) / (precision + sensitivity);

        % Calculate Matthew's Correlation Coefficient (MCC)
        mcc = (truePositives * trueNegatives - falsePositives * falseNegatives) / ...
              sqrt((truePositives + falsePositives) * (truePositives + falseNegatives) * ...
                   (trueNegatives + falsePositives) * (trueNegatives + falseNegatives));
        
        % Update the metric display fields
        set(handles.iouText, 'String', ['IoU: ' num2str(iou)]);
        set(handles.jaccardText, 'String', ['Jaccard Similarity: ' num2str(jaccard_similarity)]);
        set(handles.diceText, 'String', ['Dice Similarity: ' num2str(dice_similarity)]);
        set(handles.sensitivityText, 'String', ['Sensitivity: ' num2str(sensitivity)]);
        set(handles.specificityText, 'String', ['Specificity: ' num2str(specificity)]);
        set(handles.precisionText, 'String', ['Precision: ' num2str(precision)]);
        set(handles.f1Text, 'String', ['F1 Score: ' num2str(f1_score)]);
        set(handles.mccText, 'String', ['MCC: ' num2str(mcc)]);
    end
end
