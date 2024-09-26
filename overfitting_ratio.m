function overfitting_ratio
    % Create a figure for the UI
    hFig = figure('Position', [100, 100, 800, 500], 'MenuBar', 'none', ...
                  'Name', 'ROI Overfitting Metrics', 'NumberTitle', 'off', ...
                  'Resize', 'off');

    % Title text
    uicontrol('Style', 'text', 'Position', [20, 450, 760, 30], ...
              'String', 'Overfitting Ratio Calculation', ...
              'FontSize', 14, 'HorizontalAlignment', 'center', ...
              'ForegroundColor', 'red');

    % Button for selecting target ROI image
    uicontrol('Style', 'pushbutton', 'String', 'Select Target ROI Image', 'FontSize', 10,...
              'Position', [30, 400, 250, 45], 'Callback', @select_target_image);
    
    % Button for selecting identified ROI image
    uicontrol('Style', 'pushbutton', 'String', 'Select Identified ROI Image', 'FontSize', 10, ...
              'Position', [320, 400, 250, 45], 'Callback', @select_identified_image);

    % Axes for displaying images
    handles.targetAxes = axes('Units', 'pixels', 'Position', [50, 220, 300, 150]);
    handles.identifiedAxes = axes('Units', 'pixels', 'Position', [400, 220, 300, 150]);

    % Panel for displaying results
    hPanel = uipanel('Title', 'Metrics', 'FontSize', 12, ...
                     'Position', [0.1, 0.05, 0.8, 0.3]);

%     handles.tpText = uicontrol(hPanel, 'Style', 'text', 'Position', [20, 80, 250, 20], ...
%                                'String', 'TP: ', 'HorizontalAlignment', 'left');
%     handles.fpText = uicontrol(hPanel, 'Style', 'text', 'Position', [320, 80, 250, 20], ...
%                                'String', 'FP: ', 'HorizontalAlignment', 'left');
    handles.overfitText = uicontrol(hPanel, 'Style', 'text', 'Position', [20, 40, 250, 20], 'FontSize', 8,...
                                    'String', 'Overfitting Ratio: ', 'HorizontalAlignment', 'left');
    handles.normalizedText = uicontrol(hPanel, 'Style', 'text', 'Position', [320, 40, 250, 20], 'FontSize', 8,...
                                       'String', 'Normalized Area Outside ROI: ', 'HorizontalAlignment', 'left');

    % Button for calculating metrics
    uicontrol('Style', 'pushbutton', 'String', 'Calculate Metrics', 'FontSize', 10,...
              'Position', [200, 20, 400, 40], 'Callback', @calculate_metrics);

    % Placeholder for image paths
    handles.targetImage = '';
    handles.identifiedImage = '';

    guidata(hFig, handles); % Store handles

    % Function to select target ROI image
    function select_target_image(~, ~)
        [file, path] = uigetfile({'*.jpg;*.png;*.tif', 'Image Files (*.jpg, *.png, *.tif)'}, 'Select Target ROI Image');
        if isequal(file, 0)
            return; % User canceled
        end
        handles = guidata(hFig);
        handles.targetImage = fullfile(path, file);
        
        % Display the selected image in the target axes
        target_roi = imread(handles.targetImage);
        target_roi = imresize(target_roi, [150, 150]);
        axes(handles.targetAxes);
        imshow(target_roi);
        title('Target ROI Image');
        
        guidata(hFig, handles);
    end

    % Function to select identified ROI image
    function select_identified_image(~, ~)
        [file, path] = uigetfile({'*.jpg;*.png;*.tif', 'Image Files (*.jpg, *.png, *.tif)'}, 'Select Identified ROI Image');
        if isequal(file, 0)
            return; % User canceled
        end
        handles = guidata(hFig);
        handles.identifiedImage = fullfile(path, file);
        
        % Display the selected image in the identified axes
        identified_roi = imread(handles.identifiedImage);
        identified_roi = imresize(identified_roi, [150, 150]);
        axes(handles.identifiedAxes);
        imshow(identified_roi);
        title('Identified ROI Image');
        
        guidata(hFig, handles);
    end

    % Function to calculate metrics
    function calculate_metrics(~, ~)
        handles = guidata(hFig);
        
        if isempty(handles.targetImage) || isempty(handles.identifiedImage)
            errordlg('Please select both images.', 'Image Selection Error');
            return;
        end
        
        % Read and resize images
        target_roi = imread(handles.targetImage);
        identified_roi = imread(handles.identifiedImage);
        
        target_roi = imresize(target_roi, [200, 200]);
        identified_roi = imresize(identified_roi, [200, 200]);
        
        % Ensure dimensions are the same
        if ~isequal(size(target_roi), size(identified_roi))
            errordlg('Images must have the same dimensions.', 'Dimension Error');
            return;
        end
        
        % Extract pixel information
        target_pixels = target_roi(:) ~= 0; % Target class pixels
        identified_pixels = identified_roi(:) ~= 0; % Identified class pixels
        
        % Calculate areas
        target_area = sum(target_pixels);
        identified_area = sum(identified_pixels);
        
        % Calculate TP, FP, TN, and FN
        TP = sum(target_pixels & identified_pixels);
        FP = sum(~target_pixels & identified_pixels);
        TN = sum(~target_pixels & ~identified_pixels);
        FN = sum(target_pixels & ~identified_pixels);
        
        % Calculate overfitting ratio and normalized area outside ROI
        overfitting_ratio = (identified_area - target_area) / target_area;
        normalized_area_outside_roi = FP / (numel(identified_roi) - identified_area);
        
        % Update the display
%         set(handles.tpText, 'String', ['TP: ', num2str(TP)]);
%         set(handles.fpText, 'String', ['FP: ', num2str(FP)]);
        set(handles.overfitText, 'String', ['Overfitting Ratio: ', num2str(overfitting_ratio)]);
        set(handles.normalizedText, 'String', ['Normalized Area Outside ROI: ', num2str(normalized_area_outside_roi)]);
    end
end
