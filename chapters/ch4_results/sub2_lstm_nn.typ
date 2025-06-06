#import "../../abbr-impl.typ"
#import "../../abbr.typ"
== #abbr.l[LSTM]: Results
In this section, the in dept results of the #abbr.a[LSTM] model are reported. As shown in @lstm-resutls-table, the model was relatively stable across the different cluster sizes. Similar to the #abbr.a[FNN] model in @fnn-results-section, the accuracy improved with finer granularity, this may be attributed to increased class imbalance, which can artificially inflate accuracy by favoring the majority class. This could also be the case for the precision, which has decreased from 3 to 6 clusters and the specificity has increased from 3 to 6 clusters.
#figure(table(columns: 4,
  align: center,

  [*Cluster*], [*3* #sub([Experiment 1])],[*6* #sub([Experiment 1])], [*26* #sub([Experiment 2])],

  [*Accuracy*],[$68.41% plus.minus script(0.02)$],[$69.25% plus.minus script(0.44)$],[$72.54% plus.minus script(1.68)$],
  [*AUC*], [$0.71 plus.minus script(2.4e-8)$],[$0.71 plus.minus script(1.9e-05)$],[$0.76 plus.minus script(1.9e-5)$],
  [*F1-score*], [$0.67 plus.minus script(2.2e-6)$],[$0.65 plus.minus script(3e-7)$],[$0.6 plus.minus script(5.5e-5)$],
  [*Precision*], [$0.68 plus.minus script(9.1e-6)$],[$0.65 plus.minus script(1.6e-6)$],[$0.6 plus.minus script(6.2e-6)$],
  [*Specificity*], [$0.67 plus.minus script(1.5e-6)$],[$0.67 plus.minus script(3.6e-05)$],[$0.71 plus.minus script(8.9e-7)$],
),
caption: [Performance metrics of the #abbr.a[LSTM] model. The values represent the mean and variance over the top 3 runs out of 20 for Experiment 1, and over the top 3 of 7 runs for Experiment 2.]
)<lstm-resutls-table>
