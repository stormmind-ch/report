#import "../../abbr-impl.typ"
#import "../../abbr.typ"
=== LSTM Neural Network

*Test Set Performance*
#figure(table(columns: 4,
  align: center,

  [*Cluster*], [*3*],[*6*], [*26*],

  [*Accuracy*],[$68.41% plus.minus script(0.02)$],[$69.25 plus.minus script(0.44)$],[],
  [*AUC*], [$0.71 plus.minus script(2.4e-8)$],[$0.71 plus.minus script(1.9e-05)$],[],
  [*F1*], [$0.67 plus.minus script(2.2e-6)$],[$0.65 plus.minus script(3e-7)$],[],
  [*Precision*], [$0.68 plus.minus script(9.1e-6)$],[$0.65 plus.minus script(1.6e-6)$],[],
  [*Specificity*], [$0.67 plus.minus script(1.5e-6)$],[$0.67 plus.minus script(3.6e-05)$],[],
),
caption: [Performance Metrics of the #abbr.a[LSTM] model. We provide the mean over the top 3 of the 20 runs and the variance.]
)<lstm-resutls-table>
#figure(
  image("images/lstm-roc.png", width: 50%),
  caption: [Training of the #abbr.a[FNN]]
)<fnn_roc>

#figure(
  image("images/lstm-classification-report.png", width: 50%),
  caption: [Confusion Matrix of the #abbr.a[FNN]]
)<cr_fnn>