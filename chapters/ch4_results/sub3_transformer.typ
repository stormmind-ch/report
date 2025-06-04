#import "../../abbr-impl.typ"
#import "../../abbr.typ"
=== Transformer

*Cross Validation Results*

*Test Set Performance*
#figure(table(columns: 4,
  align: center,

  [*Cluster*], [*3*],[*6*], [*26*],

  [*Accuracy*],[$68.14% plus.minus script(0.00)$],[$70.25% plus.minus script(0.00)$],[],
  [*AUC*], [$0.72 plus.minus script(9.6e-5)$],[$0.74 plus.minus script(6.2e-6)$],[],
  [*F1*], [$0.68 plus.minus script(1.4e-6)$],[$0.67 plus.minus script(7.9e-8)$],[],
  [*Precision*], [$0.68 plus.minus script(4.6e-7)$],[$0.66 plus.minus script(9.5e-8)$],[],
  [*Specificity*], [$0.67 plus.minus script(2.9e-6)$],[$0.69 plus.minus script(1.8e-6)$],[],
),
caption: [Performance Metrics of the Transformer model. We provide the mean over the top 3 of the 20 runs and the variance]
)<fnn-resutls-table>
