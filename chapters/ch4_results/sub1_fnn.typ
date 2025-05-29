#import "@preview/abbr:0.2.3"
=== Feedforward Neural Network: Results
//TODO

The feedforward network achieved stable training behavior across 100 epochs, as shown in. Both training and validation loss converged early and remained relatively flat, suggesting a well-calibrated optimization setup. While the training loss steadily decreased, the validation loss plateaued, indicating that the model did not overfit and generalized reasonably well to unseen data.

Performance metrics such as accuracy, F1 score, precision, and recall also stabilized early during training, as shown in /*TODO*/. The final validation accuracy reached approximately 66%, with an F1 score around 0.59. This balance between precision and recall suggests that the model was able to capture patterns in both classes despite class imbalance.

The confusion matrix () further illustrates the model’s performance. Class 0 (no storm damage) was predicted with high accuracy (1730 true positives vs. 492 false positives), while Class 1 (storm damage) showed moderate performance (534 true positives vs. 376 false negatives). Although the model exhibits a slight bias toward the majority class, it still correctly identifies a significant proportion of storm damage events, which is critical for real-world risk prediction.
#figure(
  image("images/fnn-roc.png", width: 50%),
  caption: [Training of the #abbr.a[FNN]]
)<fnn_roc>

#figure(
  image("images/fnn-classificaiton-report.png", width: 50%),
  caption: [Confusion Matrix of the #abbr.a[FNN]]
)<cr_fnn>



Overall, the feedforward network serves as a solid baseline, offering balanced generalization and a reliable starting point for evaluating more complex architectures.