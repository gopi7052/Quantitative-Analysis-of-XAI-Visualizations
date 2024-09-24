# XAI_Quantitative_Analysis

Explainable Artificial Intelligence (XAI) is crucial for enhancing the transparency, interpretability, and trustworthiness of artificial intelligence models, particularly in sectors such as healthcare, agriculture, and various engineering applications. However, current XAI based studies predominantly rely on qualitative evaluations, which involve subjective visual examination of model explanations. These methods are often inconsistent among evaluators and face challenges related to scalability, reproducibility, and trustworthiness. Our study addresses these limitations by introducing a robust quantitative approach for reliable performance evaluation. In this study, we proposed a three-stage methodology to comprehensively evaluate deep learning models in terms of both their decision-making capabilities (classification performance) and their ability to select significant features for proper decision-making. To our knowledge, this is the first study to employ a purely quantitative approach for evaluating explanations generated by XAI methods. Our methodology offers a scalable, reproducible and reliable framework for the evaluation of the performance of deep learning models, making significant contributions to the field of XAI.

## Instructions
### Train pre-trained models
The Train_Pre_trained_model.m script trains a pre-trained model on an augmented rice disease image dataset. It replaces the final layers of the pre-trained network with new fully connected and classification layers, performs training with Adam optimizer, evaluates the model using performance metrics, and displays a confusion matrix and performance metrics like accuracy, precision, recall, and MCC.

### Extract Top 'n' features
The "Extract_top_Features.m" file implements a script for image classification using a trained neural network. It resizes an input image, classifies it, and generates LIME (Local Interpretable Model-agnostic Explanations) explanations. The script visualizes the top features influencing the classification decision and saves the resulting figures to specified paths.
