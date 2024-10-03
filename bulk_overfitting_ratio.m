function bulk_overfitting_ratio
    % Create figure window
    fig = uifigure('Name', 'Overfitting Ratio Calculator', 'Position', [100, 100, 600, 400]);

    % Create a grid layout for better organization
    gl = uigridlayout(fig, [8, 2]); % Added extra row for title
    gl.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
    gl.ColumnWidth = {'1x', '2x'};
    
    % Create title label centered at the top
    titleLabel = uilabel(gl, 'Text', 'Overfitting Ratio Calculation');
    titleLabel.FontSize = 16;
    titleLabel.FontWeight = 'bold';
    titleLabel.HorizontalAlignment = 'center';
    titleLabel.Layout.Row = 1;
    titleLabel.Layout.Column = [1, 2];
    titleLabel.FontColor = 'r'; % Span across both columns
    
    % Create button for selecting Ground Truth images
    gtButton = uibutton(gl, 'push', 'Text', 'Ground Truth Images Folder', ...
        'ButtonPushedFcn', @(btn, event) selectGTImages());
    gtButton.Layout.Row = 2;
    gtButton.Layout.Column = 1;

    % Create label to display selected Ground Truth images paths
    gtLabel = uilabel(gl, 'Text', 'No Ground Truth Images Selected');
    gtLabel.Layout.Row = 2;
    gtLabel.Layout.Column = 2;

    % Create button for selecting Model Features images
    modelButton = uibutton(gl, 'push', 'Text', 'Maked n Feature Images Folder', ...
        'ButtonPushedFcn', @(btn, event) selectModelImages());
    modelButton.Layout.Row = 3;
    modelButton.Layout.Column = 1;

    % Create label to display selected Model Features images paths
    modelLabel = uilabel(gl, 'Text', 'No Maked n Feature Images Selected');
    modelLabel.Layout.Row = 3;
    modelLabel.Layout.Column = 2;

    % Create button to calculate the Overfitting Ratio
    calculateButton = uibutton(gl, 'push', 'Text', 'Calculate Overfitting Ratio', ...
        'ButtonPushedFcn', @(btn, event) calculateOverfitting());
    calculateButton.Layout.Row = 4;
    calculateButton.Layout.Column = 1;

    % Create a panel to display the result
    resultPanel = uipanel(gl, 'Title', 'Results:', 'FontWeight', 'bold');
    resultPanel.Layout.Row = [5, 8]; % Spanning 4 rows for result panel
    resultPanel.Layout.Column = [1, 2]; % Spanning across both columns

    % Create label to display the result inside the result panel
    resultLabel = uilabel(resultPanel, 'Position', [45, 45, 200, 35], 'Text', 'Overfitting Ratio: ');

    % Variables to hold selected image paths
    gtImagePaths = {};
    modelImagePaths = {};

    % Function for selecting Ground Truth images
    function selectGTImages()
        [files, path] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files'}, 'Select Ground Truth Images', 'MultiSelect', 'on');
        if isequal(files, 0)
            gtLabel.Text = 'No Ground Truth Images Selected';
            gtImagePaths = {};
        else
            if iscell(files) % If multiple files are selected
                gtImagePaths = fullfile(path, files);
                gtLabel.Text = ['Selected Ground Truth Images: ', strjoin(gtImagePaths, ', ')];
            else % Only one file selected
                gtImagePaths = {fullfile(path, files)};
                gtLabel.Text = ['Selected Ground Truth Image: ', gtImagePaths{1}];
            end
        end
        
        figure(fig); % Ensure that the GUI window remains open and focused
    end

    % Function for selecting Model Features images
    function selectModelImages()
        [files, path] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files'}, 'Select Maked n Feature Images', 'MultiSelect', 'on');
        if isequal(files, 0)
            modelLabel.Text = 'No Maked n Feature Images Selected';
            modelImagePaths = {};
        else
            if iscell(files) % If multiple files are selected
                modelImagePaths = fullfile(path, files);
                modelLabel.Text = ['Selected Maked n Feature Images: ', strjoin(modelImagePaths, ', ')];
            else % Only one file selected
                modelImagePaths = {fullfile(path, files)};
                modelLabel.Text = ['Selected Maked n Feature Image: ', modelImagePaths{1}];
            end
        end
        
        figure(fig); % Ensure that the GUI window remains open and focused
    end

    % Callback function for calculating Overfitting Ratio
    function calculateOverfitting()
        if isempty(gtImagePaths) || isempty(modelImagePaths)
            uialert(fig, 'Please select both Ground Truth and Maked n Feature images.', 'Missing Images');
            return;
        end

        % Initialize overfitting ratio
        totalOverfittingRatio = 0;

        % Loop through selected Ground Truth images
        for i = 1:numel(gtImagePaths)
            % Read and process Ground truth image
            A = imread(gtImagePaths{i});
            I1 = im2gray(A);
            BW1 = imresize(im2bw(I1, 0.1), [200, 200]);

            % Read and process Model extracted features image
            B = imread(modelImagePaths{min(i, numel(modelImagePaths))}); % Use the same index for model image or the last one
            I2 = im2gray(B);
            BW2 = imresize(im2bw(I2, 0.1), [200, 200]);

            % Calculate Overfitting Ratio
            diff_BW2_BW1 = im2bw(BW2 - BW1);  % Elements in BW2 that are not in BW1
            overfitting_ratio = nnz(diff_BW2_BW1) / nnz(BW2);
            totalOverfittingRatio = totalOverfittingRatio + overfitting_ratio;
        end

        % Calculate average Overfitting Ratio
        averageOverfittingRatio = totalOverfittingRatio / numel(gtImagePaths);
        
        % Update result label inside the panel
        resultLabel.Text = ['Overfitting Ratio: ' num2str(averageOverfittingRatio)];
        
        figure(fig); % Ensure that the GUI window remains open and focused
    end
end
