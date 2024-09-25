# XAI_Quantitative_Analysis [MATLAB]

## Description
Explainable Artificial Intelligence (XAI) is essential for making AI models more transparent, interpretable, and trustworthy. As AI systems are increasingly deployed in critical sectors like healthcare, agriculture, and finance, understanding how these models make decisions becomes crucial to ensure their reliability and fairness. XAI techniques provide insights into the reasoning behind AI decisions, helping users to trust and validate the outputs, particularly in high-stakes applications.
We developed the MATLAB toolbox for Local Interpretable Model-Agnostic Explanations (LIME) provides an intuitive, user-friendly interface for visualizing and analyzing deep learning model explanations. It allows users to adjust parameters, generate LIME visualizations for multiple images, and assess model decision-making. The toolbox facilitates both qualitative and quantitative analysis, offering features to evaluate model performance and decision-making transparency. Users can examine the important features selected by models and conduct in-depth quantitative analysis. Additionally, the toolbox calculates overfitting ratios to more accurately assess the validity of model explanations. 

## Features
Here are the features provided by each script:
### 1. Train and save pre-trained deep learning models
The _Train_Pre_trained_model.m_ script trains a pre-trained model on an augmented rice disease image dataset. It replaces the final layers of the pre-trained network with new fully connected and classification layers, performs training with Adam optimizer, evaluates the model using performance metrics, and displays a confusion matrix and performance metrics like accuracy, precision, recall, and MCC.

### 2. Extract Top 'n' features using LIME
The MATLAB function (_lime_extract_features.m_) UI offers a comprehensive and user-friendly interface designed for model interpretation using LIME (Local Interpretable Model-agnostic Explanations). The interface allows users to load a trained deep learning model, select an image for analysis, and choose an output folder for saving results. The layout includes buttons to load the model, select an image, and define the output folder, with additional functionality to adjust the number of top features through a dropdown menu. Upon starting the analysis, the UI displays multiple outputs: the original image, a heatmap with LIME explanations, and a masked image showing the top features. A binary masked image is also generated to visualize significant areas of the input image. These results can be saved as PDF files or images for further review. The UI provides control options for pausing or stopping the process, ensuring flexibility. Overall, the tool helps in understanding which parts of an image are most influential in the model's decision-making process.

![LIME_Explanation](https://github.com/user-attachments/assets/4f72d621-2e3c-4112-bab4-74a223d518fd)

### 3. Quantitative Analysis
This MATLAB function creates a graphical user interface (UI) for quantitative evaluation metrics in Explainable AI (XAI) analysis. It allows users to load two images: a ground truth image and a masked features image. The UI displays these images side by side and provides a button to calculate evaluation metrics, including IoU, Jaccard similarity, Dice similarity, sensitivity, specificity, precision, F1 score, and Matthew's correlation coefficient (MCC). Metrics are computed based on image comparison and displayed in a panel below the images. The UI enables easy visualization and comparison of image-based quantitative metrics.

![Quantitative_Metrics](https://github.com/user-attachments/assets/bdc248f1-9b0c-445c-880d-3b60c132e797)

### 4. Overfitting ratio
This MATLAB function calculates the overfitting ratio between a target ROI image and an identified ROI image. It includes buttons for selecting images, displaying them on axes, and a panel to show metrics. Users select both images, which are resized and displayed in two axes. The "Calculate Metrics" button computes areas, true positives, false positives, and overfitting ratio based on pixel values. The results, including the overfitting ratio and the normalized area outside ROI, are displayed in the panel.

![Overfitting_Ratio](https://github.com/user-attachments/assets/e69f1835-ff5f-4171-be65-a07e0246ce48)



## Authors
1. Hari Kishan Kondaveeti, Ph.D
2. Chinna Gopi Simhadri, (Ph.D)
