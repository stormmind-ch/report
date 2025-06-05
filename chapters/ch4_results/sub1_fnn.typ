#import "../../abbr-impl.typ"
#import "../../abbr.typ"
== #abbr.pll[FNN]: Results
In this section, the in dept results of the #abbr.a[FNN] model are reported. As shown in @fnn-results-table-detail, the models was relativly stable across the different cluster sizes. Although accuracy improved with finer granularity, this may be attributed to increased class imbalance, which can artificially inflate accuracy by favoring the majority class.
#figure(table(columns: 4,
  align: center,

  [*Cluster*], [*3*],[*6*], [*26*], 

  [*Accuracy*],[$67.55% plus.minus script(0.35)$],[$70.68% plus.minus script(0.56)$],[$68.71% plus.minus script(0.02)$],
  [*AUC*], [$0.71 plus.minus script(2.2e-5)$],[$0.72 plus.minus script(5.5e-5)$],[$0.72 plus.minus script(2.9e-6)$],
  [*F1*], [$0.66 plus.minus script(3.6e-5)$],[$0.67 plus.minus script(9.9e-6)$],[$0.67 plus.minus script(3.7e-7)$],
  [*Precision*], [$0.68 plus.minus script(3.8e-5)$],[$0.66 plus.minus script(6.7e-6)$],[$0.67 plus.minus script(7.7e-8)$],
  [*Specificity*], [$0.66 plus.minus script(3.5e-5)$],[$0.68 plus.minus script(3.3e-5)$],[$0.67 plus.minus script(4e-6)$],
),
caption: [Performance Metrics of the #abbr.a[FNN] model. We provide the mean and variance over the top 3 runs.]
)<fnn-results-table-detail>

