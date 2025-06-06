#import "../../abbr-impl.typ"
#import "../../abbr.typ"
== #abbr.pll[FNN]: Results<fnn-results-section>
In this section, the in dept results of the #abbr.a[FNN] model are reported. As shown in @fnn-results-table-detail, the model was relatively stable across the different cluster sizes. Although accuracy improved with finer granularity, this may be attributed to increased class imbalance, which can artificially inflate accuracy by favoring the majority class. This could also be the case for the precision, which has decreased from 3 to 6 clusters and the specificity has increased from 3 to 6 clusters.
#figure(table(columns: 4,
  align: center,

  [*Cluster*], [*3* #sub([Experiment 1])],[*6* #sub([Experiment 1])], [*26* #sub([Experiment 2])], 

  [*Accuracy*],[$67.55% plus.minus script(0.35)$],[$70.68% plus.minus script(0.56)$],[$68.1% plus.minus script(0.03)$],
  [*AUC*], [$0.71 plus.minus script(2.2e-5)$],[$0.72 plus.minus script(5.5e-5)$],[$0.71 plus.minus script(3.1e-7)$],
  [*F1-score*], [$0.66 plus.minus script(3.6e-5)$],[$0.67 plus.minus script(9.9e-6)$],[$0.67 plus.minus script(2.3e-6)$],
  [*Precision*], [$0.68 plus.minus script(3.8e-5)$],[$0.66 plus.minus script(6.7e-6)$],[$0.66 plus.minus script(2.3e-6)$],
  [*Specificity*], [$0.66 plus.minus script(3.5e-5)$],[$0.68 plus.minus script(3.3e-5)$],[$0.67 plus.minus script(4.2e-6)$],
),
caption: [Performance metrics of the #abbr.a[FNN] model. The values represent the mean and variance over the top 3 runs out of 20 for Experiment 1, and over the top 3 of 7 runs for Experiment 2.]
)<fnn-results-table-detail>

