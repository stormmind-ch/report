#import "@preview/abbr:0.2.3"


The goal of the experiments was to identify the most suitable deep learning architecture for predicting storm damage events based on weather-related input features. We evaluated different types of neural networks, beginning with a baseline #abbr.l[FNN], and compared their performance on a held-out test set.

*Datasets*

As shown in @datasets_split, the dataset was split temporally into a training set and a hold-out test set in order to simulate realistic forecasting scenarios and to prevent information leakage. The training set spans the years 1971–2013, while the test set covers the period from 2013 to 2023.

To further support model selection and hyperparameter tuning, the training set was divided using 5-fold time-aware cross-validation. Each fold was split into a training and a validation subset. This approach allowed us to assess model generalization performance over temporally consistent data splits, where earlier data was used for training and later data for validation.

All features were normalized using Z-score normalization, defined as $Z = (X - mu) / sigma$ @StandardScore2025. The mean $mu$ and standard deviation $sigma$ were computed from the training set only, and these values were reused to normalize the test set. This ensures that no information from the test set leaks into the training or validation stages.

#figure(
  table(
    columns: 3,
    align: (left, center, right),
    table.header([Set], [Number of Patterns], [Years]),
    [Train], [10014], [1971–2013],
    [Test], [3132], [2013–2023]
  ),
  caption: [Summary of dataset splits used for training and evaluation.]
)<datasets_split>


*Training Pipeline*

The complete training workflow is illustrated in @training-pipeline. Model development was carried out using PyTorch, and experiment tracking including metric logging, configuration management, and model evaluation was conducted using #abbr.a[WANDB].

We first initialized the environment by detecting the available compute device (CPU or GPU) and configuring the training run. 

The dataset was initially split into training and test sets as shown in @datasets_split, followed by 5-fold cross-validation on the training portion using a custom splitter based on SciKit-Learn's `BaseCrossValidator` @ScikitlearnMachineLearning. This custom method, `ClusteredTimeSeriesSplit`, is shown in @cv-visualization. It ensures chronological consistency by keeping validation data strictly later in time than training data within each geographic cluster.

#figure(image("images/fold-cross-validation.png", width: 50%),
caption: [Chronological 5-fold cross-validation. Each fold validates on a later time window, preserving the time series structure.])
<cv-visualization>

Within each fold, the model was trained over multiple epochs, which is shown in @training-pipeline on the 4th line. To address class imbalance in the storm damage classes, class-specific weights were computed from the training set and used in the respective loss function. At the end of each epoch, the models performance was evaluated on the validation fold using accuracy, precision, recall, and F1 score, which were logged via #abbr.a[WANDB].

After all folds were completed, the model with the highest average F1 score across validation folds was selected. As shown in steps 5 and 6 of @training-pipeline, this model was retrained on the entire training set without validation and subsequently evaluated on the held-out test set. The final performance metrics were recorded in the experiment summary for comparison between architectures.

#figure(image("images/training-pipeline.png", width: 40%),
caption: [End-to-end training pipeline, from dataset preparation through cross-validation and final testing.])<training-pipeline>



=== #abbr.a[FNN] based forecasting model <fnn_setup>
Our first experiment employed a baseline #abbr.l[FNN], whose architecture is illustrated in @fnn_experiment. The network consists of 10 fully connected layers with ReLU activation functions. The model was trained using the Adam optimizer and crossentropyloss.

#figure(
  image("images/fnn_illustration-experiment.png", width: 70%),
  caption: [Illustration of the used #abbr.a[FNN]]
  )<fnn_experiment>



*Input features*

The input to the #abbr.a[FNN] consisted of three weather-related variables: mean temperature at 2 meters, total rainfall, and sunshine duration. All features were normalized to zero mean and unit variance, as described in @data, and were provided on a weekly basis for each coordinate in the dataset.

*Training*

The Feedforward Neural Network was trained to minimize the weighted cross-entropy loss, using class weights computed via sklearn's @ScikitlearnMachineLearning `compute_class_weight` function. This approach addresses class imbalance in the training data by assigning higher loss penalties to underrepresented classes. The computed class weights were passed during initailitation to the PyTorch @PyTorchFoundation `CrossEntropyLoss` function, allowing the model to pay more attention to minority class predictions.

We used the Adam @kingmaAdamMethodStochastic2017 optimizer with a learning rate of $1e^(-4)$, as it provides adaptive learning rate updates and has been shown to work well in practice for deep learning tasks involving sparse gradients. To further improve training stability and avoid overfitting, we employed a learning rate scheduler (`ReduceLROnPlateau`), which reduces the learning rate by a factor of 0.5 if the validation loss does not improve for 5 consecutive epochs.

Training was performed over 100 epochs using mini-batches of 64 patterns per batch. After each epoch, the model was evaluated on the validation set to track performance metrics including accuracy, F1 score, precision, and recall. These metrics allowed us to monitor not only the raw predictive performance, but also the model's balance between false positives and false negatives, which is particularly important in the context of storm damage prediction.

This training setup was chosen to ensure stable convergence, account for class imbalance, and enable dynamic adjustment of the learning rate during training.

=== #abbr.pla[LSTM] based Forecasting Model

To model temporal dependencies in the weather-related input features, we implemented a sequence model based on Long Short-Term Memory (#abbr.a[LSTM]) units. The architecture is illustrated in @lstm-model and consists of a stack of LSTM layers followed by a fully connected output layer.

The LSTM block receives as input a multivariate time series of weather features, such as temperature, rainfall, and snow accumulation, over a fixed sequence window. The `input_size` parameter determines the number of input features per time step, while `hidden_size` controls the dimensionality of the hidden state. To increase the model’s representational capacity and capture higher-level temporal abstractions, multiple LSTM layers were stacked (`num_layers` > 1).

The output of the final LSTM layer is a hidden state for each time step in the input sequence. To reduce this sequence to a single prediction, we extract the hidden state from the last time step (`x = x[:, -1, :]`). This strategy assumes that the final time step contains the most relevant information for predicting the next event, which aligns with common practices in time series classification and forecasting.

The last layer of the model is a fully connected linear layer that maps the LSTM output to a 2-dimensional output space, corresponding to a binary classification task (e.g., damage/no damage). This compact architecture was chosen for its balance between temporal modeling capacity and computational efficiency, making it suitable for forecasting storm-related events over long historical time spans.

#figure(image("images/lstm_illustration-experiment.png"), caption: [Architecture of the LSTM-based forecasting model. The model consists of stacked LSTM layers followed by a fully connected output layer.])<lstm-model>


=== Transformer-Based Forecasting Model

In addition to recurrent architectures, we implemented a Transformer-based model to evaluate whether attention mechanisms could better capture long-range temporal dependencies in the weather time series data. The architecture is shown in  and is composed of a sequence embedding layer, positional encoding, stacked Transformer encoder layers, and a feedforward output projection.

The input to the model is a multivariate sequence of weather observations. Each input vector at a time step is first passed through a linear embedding layer that projects it to a fixed-dimensional representation (`d_model`). Since Transformers do not have a built-in notion of sequence order, a trainable positional encoding is added to each embedded input vector. This enables the model to learn relative and absolute temporal positions within the input sequence.

The core of the architecture is a Transformer encoder block consisting of `num_layers` stacked layers of multi-head self-attention and feedforward sub-layers. These layers allow each time step to attend to all others in the sequence, enabling the model to capture both short- and long-term dependencies without recurrence. The encoder is applied in a symmetric fashion (`x` is passed as both source and target), as no autoregressive decoder is needed for our forecasting task.

The Transformer output is then passed through an additional feedforward layer with ReLU activation, followed by a final linear layer that maps the representation to the target space. As in the LSTM model, only the representation of the final time step is used for prediction (`x[:, -1, :]`), assuming the most recent observations are most relevant for forecasting the next event.

This architecture was selected to leverage the Transformer’s strength in modeling global dependencies and to benefit from parallelizable training, which is particularly valuable for long weather sequences. Additionally, the attention mechanism offers better interpretability by allowing insight into which parts of the sequence the model attends to during prediction.
#figure(image("images/transformer-illustration.png"),
caption: [Architecture of the Transformer-based forecasting model. The model includes input embeddings, positional encoding, stacked self-attention layers, and a feedforward output module.])

=== Model Comparison Summary

Each of the architectures evaluated—#abbr.a[FNN], #abbr.a[LSTM], and the Transformer offers distinct capabilities for modeling storm damage from weather sequences. The FNN serves as a strong non-sequential baseline, the LSTM provides temporal memory with limited range, and the Transformer introduces long-range dependency modeling via attention. This progression allowed us to evaluate how increasing architectural complexity affects predictive performance in our task.
