#import "@preview/abbr:0.2.3"


The goal of the experiments was to identify the most suitable deep learning architecture for predicting storm damage events based on weather-related input features. We evaluated different types of neural networks, beginning with a baseline #abbr.l[FNN], and compared their performance on a held-out test set. The result of the different models are discussed in @results-ai.

*Datasets*

As shown in @datasets_split, the dataset was split temporally into a training set and a hold-out test set in order to simulate realistic forecasting scenarios and to prevent information leakage. The training set spans the years 1972–2013, while the test set covers the period from 2013 to 2023.

To further support model selection and hyperparameter tuning, the training set was divided using 5-fold time-aware cross-validation. Each fold was split into a training and a validation subset. This approach allowed us to assess model generalization performance over temporally consistent data splits, where earlier data was used for training and later data for validation.

All features were normalized using Z-score normalization, defined as $Z = (X - mu) / sigma$ @StandardScore2025. The mean $mu$ and standard deviation $sigma$ were computed from the training set only, and these values were reused to normalize the test set. This ensures that no information from the test set leaks into the training or validation stages.

#figure(
  table(
    columns: 6,
    table.header([Nr of Clusters], [Set], [Number of Patterns], [Years], [Damages], [No Damages]),
    [3],[Train], [6'573], [1971–2013], [2'242],[4'331],
    [3],[Test], [1'566], [2013–2023], [697], [859],
    [6],[Train], [13'146], [1971–2013], [2'872],[10'274],
    [6],[Test], [3'132], [2013–2023], [910], [2'222],

  ),
  caption: [Summary of dataset splits used for training and evaluation.]
)<datasets_split>


*Training Pipeline*

The complete training workflow is illustrated in @training-pipeline. Model development was carried out using PyTorch, and experiment tracking including metric logging, configuration management, and model evaluation was conducted using #abbr.a[WANDB].

We first initialized the environment by detecting the available compute device (CPU or GPU) and configuring the training run. All the models were trained on a NVIDIDA L4 Tensor Core GPU.

The dataset was initially split into training and test sets as shown in @datasets_split, followed by 5-fold cross-validation on the training portion using a custom splitter based on SciKit-Learn's `BaseCrossValidator` @ScikitlearnMachineLearning. This custom method, `ClusteredTimeSeriesSplit`, is shown in @cv-visualization. It ensures chronological consistency by keeping validation data strictly later in time than training data within each geographic cluster.

#figure(image("images/fold-cross-validation.png", width: 50%),
caption: [Chronological 5-fold cross-validation. Each fold validates on a later time window, preserving the time series structure.])
<cv-visualization>

Within each fold, the model was trained over multiple epochs, which is shown in @training-pipeline on the 4th line. We used the Adam @kingmaAdamMethodStochastic2017 optimizer, as it provides adaptive learning rate updates and has been shown to work well in practice for deep learning tasks involving sparse gradients. To further improve training stability and avoid overfitting, we employed a learning rate scheduler (`ReduceLROnPlateau`), which reduces the learning rate by a factor of 0.5 if the validation loss does not improve for 5 consecutive epochs.
To address class imbalance in the storm damage classes, class-specific weights were computed from the training set and used in the respective loss function. At the end of each epoch, the models performance was evaluated on the validation fold using accuracy, precision, recall, and F1 score, which were logged via #abbr.a[WANDB].

After all folds were completed, the model with the highest average F1 score across validation folds was selected. As shown in steps 5 and 6 of @training-pipeline, this model was retrained on the entire training set without validation and subsequently evaluated on the held-out test set. The final performance metrics were recorded in the experiment summary for comparison between architectures.

#figure(image("images/training-pipeline.png", width: 40%),
caption: [End-to-end training pipeline, from dataset preparation through cross-validation and final testing.])<training-pipeline>

=== Initial Findings and Design Decisions

In the early stages of model development, we conducted exploratory experiments using a prototype model to predict the exact extent of storm damage, framed either as a multi-class classification or regression task. These experiments included variations in the number of clusters $k$ used for spatial grouping. However, initial results revealed that the model consistently converged toward predicting only the majority class or mean value, regardless of the input sequence. This behavior led to poor discriminative power in practice.

As shown in @data, the dataset is highly imbalanced, with the vast majority of events corresponding to class 0 (no damage) or low average damage values. This imbalance caused the model to exploit the loss function by minimizing risk through constant prediction of the dominant class. Consequently, it failed to capture meaningful distinctions between damage levels.

Given these outcomes and the underlying class distribution, we reframed the problem as a binary classification task: predicting whether any storm damage will occur (damage/no-damage). This formulation reduces modeling complexity and mitigates the effects of class imbalance, while still offering practical value for early-warning systems and resource allocation.

To address the problem of class imbalance, all the models were trained to minimize the loss function, using class weights computed via sklearn's @ScikitlearnMachineLearning `compute_class_weight` function. This approach assigns higher loss penalties to underrepresented classes. The computed class weights were passed during initailitation to the PyTorch @PyTorchFoundation `CrossEntropyLoss` function, allowing the model to pay more attention to minority class predictions. 



=== #abbr.a[FNN] based forecasting model <fnn_setup>
Our first experiment employed a baseline #abbr.l[FNN], whose architecture is illustrated in @fnn_experiment. The #abbr.a[FNN] was used as a baseline model, as they are simple to create and light in computation time. 
The network consists of 10 fully connected layers with ReLU activation functions. This depth was chosen to for a sufficient level of non-linearity to capture complex feature interactions, while keeping the model small enough to avoid overfitting. The model was trained using the Adam optimizer and Cross Entropy Loss Function. 

#figure(
  image("images/fnn_illustration-experiment.png", width: 70%),
  caption: [Illustration of the  #abbr.a[FNN]: 3 Input Neurons, 2 Output Neurons. 8 hidden layers with Neurons variing between 8 and 64 as shown in the illustration respectively.]
  )<fnn_experiment>

*Input features*

The input to the #abbr.a[FNN] consisted of three weather-related variables: mean temperature at 2 meters, total rainfall, and sunshine duration. All features were normalized to zero mean and unit variance, as described in @data, and were provided on a weekly basis for each cluster in the dataset.



=== #abbr.pla[LSTM] based Forecasting Model<lstm-setup>

To model temporal dependencies in the weather-related input features, we implemented a sequence model based on (#abbr.a[LSTM]) units. The architecture is illustrated in @lstm-model and consists of a stack of #abbr.a[LSTM] layers followed by a fully connected output layer.

The LSTM block, shown in the middle of @lstm-model, receives as input a multivariate time series of weather features, such as temperature, rainfall, and temperature, over a fixed sequence window. To increase the model’s representational capacity and capture higher-level temporal abstractions, multiple #abbr.[LSTM] layers were stacked, as shown in @lstm-illustration. This resulted in a additional hyperparameter $k$, for the number of stacks.

The output of the final LSTM layer is a hidden state for each time step in the input sequence. To reduce this sequence to a single prediction, we extract the hidden state from the last time step. This strategy assumes that the final time step contains the most relevant information for predicting the next event, which aligns with common practices in time series classification and forecasting as shown in the official PyTorch documentation @PyTorchFoundation.

The last layer of the model is a fully connected linear layer that maps the #abbr.a[LSTM] output to a 2-dimensional output space, corresponding to a binary classification task. This is shown on the right side in @lstm-model.
This architecture was chosen based on the findings of Steven Elsworht et. al in "Time Series Forecasting Using LSTM Networks: A Symbolic Approach" @elsworthTimeSeriesForecasting2020. Additionally, this architecture had the advantages of having a balance between compactness and computational efficiency, which made it suitable for forecasting storm damages over a long historicaltime span. 

#figure(image("images/lstm_illustration-experiment.png"), caption: [Architecture of the LSTM-based forecasting model. The model consists of stacked LSTM layers followed by a fully connected output layer.])<lstm-model>


=== Transformer-Based Forecasting Model

In addition to recurrent architectures, we implemented a Transformer-based model to evaluate whether attention mechanisms could better capture long-range temporal dependencies in the weather time series data. The architecture is shown in @transformer-architecture and is composed of a sequence embedding layer, positional encoding, stacked Transformer encoder layers, and a feedforward output layer.

The input to the model is a multivariate sequence of weather observations, same as in @lstm-setup. Each input vector at a time step is first passed through a linear embedding layer that projects it to a fixed-dimensional representation (`d_model`). Since Transformers do not have a built-in notion of sequence order, a trainable positional encoding is added to each embedded input vector. This enables the model to learn relative and absolute temporal positions within the input sequence. @vaswaniAttentionAllYou2023

TODO: Embedding

TODO: Position Encoding using @iraniPositionalEncodingTransformerBased2025

The core of the architecture is a Transformer encoder block consisting of `num_layers` stacked layers of multi-head self-attention and feedforward sub-layers. Here we used the built in Transformer module of the PyTorch Library @PyTorchFoundation.
These layers allow each time step to attend to all others in the sequence, enabling the model to capture both short- and long-term dependencies without recurrence. The encoder is applied in a symmetric fashion (`x` is passed as both source and target), as no autoregressive decoder is needed for our forecasting task.

The Transformer output is then passed through an additional feedforward layer with ReLU activation, followed by a final linear layer that maps the representation to the target space of 2. As in the LSTM model, only the representation of the final time step is used for prediction, assuming the most recent observations are most relevant for forecasting the next event.

This architecture was selected to leverage the Transformer’s strength in modeling global dependencies and to benefit from parallelizable training, which is particularly valuable for long weather sequences.

#figure(
  image("images/transformer-illustration.png"),
  caption: [
    Architecture of the Transformer-based forecasting model. The model includes input embeddings, positional encoding, stacked self-attention layers, and a feedforward output module.
    ]
)<transformer-architecture>

=== Model Comparison Setup

The three evaluated architectures #abbr.a[FNN], #abbr.a[LSTM], and the Transformer offer distinct capabilities for modeling storm damage based on weather sequences. The Feedforward Neural Network (FNN) serves as a non-sequential baseline and is limited to using only the current week as input. The LSTM, in contrast, can model short- and medium-range temporal dependencies through its memory mechanism. The Transformer introduces a more powerful attention-based framework, enabling the modeling of long-range dependencies across input sequences. This architectural progression allowed us to systematically assess the relationship between model complexity and forecasting performance in a controlled setting.

To ensure a fair comparison, all models were trained under the same experimental conditions. Hyperparameter optimization was performed using the Sweep API provided by #abbr.a[WANDB], with a maximum of 20 trials per architecture. The hyperparameters were optimized via Bayesian search, which balances exploration and exploitation to efficiently converge to high-performing configurations. @WeightsBiases

#figure(
  table(
    columns: (auto, auto),
    inset: 10pt,
    align: horizon,
    table.header([*Hyperparameter*], [*Search Space*]),
    [Batch Size], [[32, 64, 128]],
    [Learning Rate], [0.00001–0.01],
    [Epochs], [10–100],
    [Sequence Length], [[0, 2, 4, 12, 52]],
  ),
  caption: [Hyperparameter search space used during model sweeps.]
)

In addition, to assess the impact of spatial aggregation on model performance, each architecture was trained using different cluster counts \( k \in \{3, 4, 5, 6\} \), which determine the number of geographic regions derived from the spatial clustering process (see @data_preparation). By evaluating model performance across different levels of spatial granularity, we aimed to determine whether finer or coarser regional segmentation improves generalization and damage detection performance.


