#import "@preview/abbr:0.2.3"
=== Transformer

*Cross Validation Results*

*Test Set Performance*
#figure(table(columns: 5,
  align: center,

  [*Cluster*], [*3*],[*4*], [*5*], [*6*],

  [*Accuracy*],[$66.75% plus.minus script(7.74)$],[],[],[],
  [*AUC*], [$0.71 plus.minus script(0.00053)$],[],[],[],
  [*F1*], [$0.65 plus.minus script(0.0048)$],[],[],[],
  [*Precision*], [$0.65 plus.minus script(0.0078)$],[],[],[],
  [*Specificity*], [$0.66 plus.minus script(0.0014)$],[],[],[],
),
caption: [Performance Metrics of the Transformer model. We provide the mean over the 20 runs and the variance]
)<fnn-resutls-table>
