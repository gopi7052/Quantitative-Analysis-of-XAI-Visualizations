function LIME_Extract_Features
    % Create the UI figure
    fig = uifigure('Position', [100 100 1000 600], 'Name', 'Model Explanation - LIME');

    
    % Add title to main UI figure
    titlePosition = [fig.Position(3)/2 - 150, fig.Position(4) - 50, 300, 30];
    uilabel(fig, 'Text', 'Model Explanation - LIME', 'FontSize', 18, 'FontWeight', 'bold', 'Position', titlePosition, 'FontColor', 'red');

    
    
    % Add components to the UI
    % Load Model button
    uibutton(fig, 'Text', 'Load Model', ...
        'Position', [30 500 100 30], ...
        'ButtonPushedFcn', @(btn, event) loadModel());
    
    % Select Image button
    uibutton(fig, 'Text', 'Select Image', ...
        'Position', [30 450 100 30], ...
        'ButtonPushedFcn', @(btn, event) selectImage());
    
    % Output folder button
    uibutton(fig, 'Text', 'Output Folder', ...
        'Position', [30 400 100 30], ...
        'ButtonPushedFcn', @(btn, event) outputFolder());
    
    % Dropdown for the number of top features
    uilabel(fig, 'Text', 'Select Num Features:', ...
        'Position', [30 350 130 30]);
    featureDropDown = uidropdown(fig, 'Position', [170 350 80 30], ...
        'Items', {'6', '8', '10', '12', '14', '16' }, ...
        'Value', '6');
    
    % Start, Pause, Stop buttons
    uibutton(fig, 'Text', 'Start', ...
        'Position', [30 300 100 30], ...
        'ButtonPushedFcn', @(btn, event) startAnalysis());
    
    uibutton(fig, 'Text', 'Pause', ...
        'Position', [150 300 100 30]);
    
    uibutton(fig, 'Text', 'Stop', ...
        'Position', [270 300 100 30]);
    
    % Create axes for displaying images/results
    ax1 = uiaxes(fig, 'Position', [350 350 200 200]);
    ax2 = uiaxes(fig, 'Position', [570 350 200 200]);
    ax3 = uiaxes(fig, 'Position', [790 350 200 200]);
    ax4 = uiaxes(fig, 'Position', [350 100 200 200]);  % Adjust position for binary image

    % Variables to store loaded model and image
    model = [];
    imageFile = '';
    savePath = '';

    % Function to load the model
    function loadModel()
        [file, path] = uigetfile('*.mat', 'Select the Trained Model');
        if isequal(file, 0)
            disp('Model loading canceled');
        else
            modelPath = fullfile(path, file);
            model = load(modelPath);
            disp(['Loaded model: ', modelPath]);
        end
    end

    % Function to select image
    function selectImage()
        [file, path] = uigetfile({'*.jpg;*.png'}, 'Select an Image');
        if isequal(file, 0)
            disp('Image selection canceled');
        else
            imageFile = fullfile(path, file);
            disp(['Selected image: ', imageFile]);
            imshow(imread(imageFile), 'Parent', ax1);
        end
    end

    % Function to select output folder
    function outputFolder()
        savePath = uigetdir('', 'Select Folder to Save Output');
        if isequal(savePath, 0)
            disp('Output folder selection canceled');
        else
            disp(['Output folder: ', savePath]);
        end
    end

    % Function to start analysis
    function startAnalysis()
        if isempty(model) || isempty(imageFile)
            uialert(fig, 'Please load a model and select an image before starting.', 'Missing Data');
            return;
        end
        
        % Read and process the selected image
        X = imread(imageFile);
        inputSize = model.Trained_Network.Layers(1).InputSize(1:2);
        X = imresize(X, inputSize);
        
        % Classify the image
        label = classify(model.Trained_Network, X);
        
        % Generate LIME explanations
        [scoreMap, featureMap, featureImportance] = imageLIME(model.Trained_Network, X, label, ...
            'Segmentation', 'grid', 'NumFeatures', 64, 'NumSamples', 3072);
        
        % Get the number of top features to display from the dropdown
        numTopFeatures = str2double(featureDropDown.Value);
        
        % Clear previous axes before displaying new images
        cla(ax2);
        cla(ax3);
        cla(ax4);
        
        % Display the original image with LIME explanations
        imagesc(scoreMap, 'Parent', ax2);
        colormap(ax2, 'jet');
        colorbar(ax2);
        title(ax2, ['LIME Explanations - Top ', num2str(numTopFeatures), ' Features']);
        axis(ax2, 'image');  % Ensure correct aspect ratio
        
        % Mask the image for top features
        [~, idx] = maxk(featureImportance, numTopFeatures);
        mask = ismember(featureMap, idx);
        maskedImg = uint8(mask) .* X;
        
        % Display the masked image for the top features
        imshow(maskedImg, 'Parent', ax3);
        title(ax3, ['Top ', num2str(numTopFeatures), ' Features']);
        
        % Convert the masked image to a binary image
        binaryImg = imbinarize(rgb2gray(maskedImg));  % Convert to grayscale and then binarize
        imshow(binaryImg, 'Parent', ax4);
        title(ax4, 'Binary Masked Image');

        % Save the figures if the output folder is specified
        if ~isempty(savePath)
            figName1 = fullfile(savePath, sprintf('LIME_Explanation_Top%d.pdf', numTopFeatures));
            exportgraphics(ax2, figName1, 'ContentType', 'vector');
            
            figName2 = fullfile(savePath, sprintf('MaskedImage_Top%d.pdf', numTopFeatures));
            exportgraphics(ax3, figName2, 'ContentType', 'vector');
            
            % Save the binary image
            binaryImgName = fullfile(savePath, sprintf('BinaryMaskedImage_Top%d.png', numTopFeatures));
            imwrite(binaryImg, binaryImgName);
            disp(['Binary image saved successfully: ', binaryImgName]);
            
            disp('Figures saved successfully.');
        end
    end
end
