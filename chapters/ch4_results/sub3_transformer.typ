#import "@preview/abbr:0.2.3"
=== Transformer

*Cross Validation Results*

*Test Set Performance*
#figure(table(columns: 5,
  align: center,

  [*Cluster*], [*3*],[*4*], [*5*], [*6*],

  [*Accuracy*],[$68.14% plus.minus script(0.00)$],[],[],[],
  [*AUC*], [$0.72 plus.minus script(9.6e-5)$],[],[],[],
  [*F1*], [$0.68 plus.minus script(1.4e-6)$],[],[],[],
  [*Precision*], [$0.68 plus.minus script(4.6e-07)$],[],[],[],
  [*Specificity*], [$0.67 plus.minus script(2.9e-6)$],[],[],[],
),
caption: [Performance Metrics of the Transformer model. We provide the mean over the top 3 of the 20 runs and the variance]
)<fnn-resutls-table>
