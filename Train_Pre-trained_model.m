clc;close all;clear;

Dataset = imageDatastore('F:\Gopi (21PHD7052)\3Paper(XAI)\XAI_Dataset_4Class', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
[Training_Data, Validation_Data] = splitEachLabel(Dataset, 0.6,'randomized');

numTrainImages = numel(Training_Data.Labels);
idx = randperm(numTrainImages,16);
figure
for i = 1:16
    subplot(4,4,i)
    I = readimage(Training_Data,idx(i));
    imshow(I)
end

%Replace the layers
net=resnet50;
lgraph = layerGraph(net);
clear net;
    
    % Number of categories
    numClasses = numel(categories(Training_Data.Labels));
    
    % New Learnable Layer
    newLearnableLayer = fullyConnectedLayer(numClasses, ...
        'Name','new_fc', ...
        'WeightLearnRateFactor',40, ...
        'BiasLearnRateFactor',40);
    
    % Replacing the last layers with new layers
    lgraph = replaceLayer(lgraph,'fc1000',newLearnableLayer);
    newsoftmaxLayer = softmaxLayer('Name','new_softmax');
    lgraph = replaceLayer(lgraph,'fc1000_softmax',newsoftmaxLayer);
    newClassLayer = classificationLayer('Name','new_classoutput');
    lgraph = replaceLayer(lgraph,'ClassificationLayer_fc1000',newClassLayer);


%Augmentation
pixelRange = [-30 30];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange);
Resized_Training_Data = augmentedImageDatastore([224 224],Training_Data, ...
    'DataAugmentation',imageAugmenter);
Resized_Validation_Data = augmentedImageDatastore([224 224], Validation_Data);

%training
Training_Options = trainingOptions('adam', ...
    'MiniBatchSize', 32,  ...
    'MaxEpochs', 30, ...
    "InitialLearnRate", 1e-4, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', Resized_Validation_Data, ...
    'ValidationFrequency', 40, ...
    "ExecutionEnvironment","gpu",...
    'Verbose', false, ...
    'Plots', 'training-progress');


Trained_Network = trainNetwork(Resized_Training_Data, lgraph, Training_Options);

%Save Model
save('rice_disease_ResNet50.mat', 'Trained_Network');
YPred = classify(Trained_Network,Resized_Validation_Data);

confusionchart(Validation_Data.Labels,YPred);
title('Confusion Matrix: ResNet50');

%Performance Metrics
figure,plotconfusion(Validation_Data.Labels,YPred)
title('Confusion Matrix: ResNet50');
cm=confusionmat(Validation_Data.Labels,YPred)
for i=1:length(cm)
    TP=cm(i,i);
    TN=sum(cm(:))-sum(cm(:,i))-sum(cm(i,:))+cm(i,i);
    FP=sum(cm(:,i))-cm(i,i);
    FN=sum(cm(i,:))-cm(i,i);
    Acc(i)=(TP+TN)/(TP+TN+FP+FN);
    Specificity(i)=TN/(FP+TN);
    Precision(i)=TP/(TP+FP);
    Recall(i)=TP/(TP+FN);
    F1_score(i)=2*TP/(2*TP+FP+FN);
    S = (TP+FN)/sum(cm(:));
    P = (TP+FP)/sum(cm(:));
    MCC(i) = (TP/sum(cm(:))-S*P)/sqrt(S*P*(1-S)*(1-P));
    ERate(i)=1-Acc(i);
    FPR(i)=1-Precision(i);
end

disp('Accuracy ....')
sprintf('The Acc is : %2f', mean(Acc))
disp('Precision ....')
sprintf('The Precision is : %2f', mean(Precision))
disp('Recall ....')
sprintf('The Recall is : %2f', mean(Recall))
disp('F1-score ....')
sprintf('The F1-score is : %2f', mean(F1_score))
disp('MCC ....')
sprintf('The MCC is : %2f', mean(MCC))
disp('Specificity ....')
sprintf('The Specificity is : %2f', mean(Specificity))
disp('FPR ....')
sprintf('The FPR is : %2f', mean(FPR))


