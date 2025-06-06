#import "../../abbr-impl.typ"
#import "../../abbr.typ"
== Transformer: Results
#figure(table(columns: 4,
  align: center,

  [*Cluster*], [*3* #sub([Experiment 1])],[*6* #sub([Experiment 1])], [*26* #sub([Experiment 2])],

  [*Accuracy*],[$68.14% plus.minus script(0.00)$],[$70.25% plus.minus script(0.00)$],[],
  [*AUC*], [$0.72 plus.minus script(9.6e-5)$],[$0.74 plus.minus script(6.2e-6)$],[],
  [*F1-score*], [$0.68 plus.minus script(1.4e-6)$],[$0.67 plus.minus script(7.9e-8)$],[],
  [*Precision*], [$0.68 plus.minus script(4.6e-7)$],[$0.66 plus.minus script(9.5e-8)$],[],
  [*Specificity*], [$0.67 plus.minus script(2.9e-6)$],[$0.69 plus.minus script(1.8e-6)$],[],
),
caption: [Performance metrics of the Transformer model. The values represent the mean and variance over the top 3 runs out of 20 for Experiment 1, and over the top 3 of 7 runs for Experiment 2.]
)<fnn-resutls-table>
