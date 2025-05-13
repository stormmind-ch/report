#import "@preview/abbr:0.2.3"


The goal of the experiments was to identify the most suitable deep learning architecture for predicting storm damage events based on weather-related input features. We evaluated different types of neural networks, beginning with a baseline #abbr.l[FNN], and compared their performance on a held-out test set.

*Datasets*

As shown in @datasets_split dataset was temporally split into training, validation, and test sets to simulate realistic forecasting scenarios and prevent information leakage. The training set spans the years 1971–2002, the validation set covers 2003–2013, and the test set includes data from 2013–2023. 

#figure(
  table(
    columns: 3,
    align: (left, center, right),
    table.header([Set], [Nr of patterns], [Years]),
    [Train], [10014], [1971 - 2002],
    [Validation], [3132], [2003 - 2013],
    [Test], [3132], [2013 - 2023]
  ),
    caption: [Datasets splits]
    
)<datasets_split>




==== Feedforward Neural Network<fnn_setup>
Our first experiment employed a baseline #abbr.l[FNN], whose architecture is illustrated in @fnn_experiment. The network consists of 10 fully connected layers with ReLU activation functions. The model was trained using the Adam optimizer and crossentropyloss.

#figure(
  image("images/fnn_illustartion.png", width: 60%),
  caption: [Illustration of the used #abbr.a[FNN]]
  )<fnn_experiment>



*Input features*

The input to the #abbr.a[FNN] consisted of three weather-related variables: mean temperature at 2 meters, total rainfall, and snow accumulation. All features were normalized to zero mean and unit variance, as described in @data, and were provided on a weekly basis for each coordinate in the dataset.

*Training*

The Feedforward Neural Network was trained to minimize the weighted cross-entropy loss, using class weights computed via sklearn's @ScikitlearnMachineLearning `compute_class_weight` function. This approach addresses class imbalance in the training data by assigning higher loss penalties to underrepresented classes. The computed class weights were passed during initailitation to the PyTorch @PyTorchFoundation `CrossEntropyLoss` function, allowing the model to pay more attention to minority class predictions.

We used the Adam @kingmaAdamMethodStochastic2017 optimizer with a learning rate of $1e^(-4)$, as it provides adaptive learning rate updates and has been shown to work well in practice for deep learning tasks involving sparse gradients. To further improve training stability and avoid overfitting, we employed a learning rate scheduler (`ReduceLROnPlateau`), which reduces the learning rate by a factor of 0.5 if the validation loss does not improve for 5 consecutive epochs.

Training was performed over 100 epochs using mini-batches of 64 patterns per batch. After each epoch, the model was evaluated on the validation set to track performance metrics including accuracy, F1 score, precision, and recall. These metrics allowed us to monitor not only the raw predictive performance, but also the model's balance between false positives and false negatives, which is particularly important in the context of storm damage prediction.

This training setup was chosen to ensure stable convergence, account for class imbalance, and enable dynamic adjustment of the learning rate during training.

==== Long Short Term Neural Network
TBD




