#import "@preview/abbr:0.2.3"
=== #abbr.pll[FNN]: Results

*Cross Validation Results*

*Test Set Performance*
#figure(table(columns: 4,
  align: center,

  [*Cluster*], [*3*],[*6*], [*26*], 

  [*Accuracy*],[$67.55% plus.minus script(0.35)$],[$70.68% plus.minus script(0.56)$],[],
  [*AUC*], [$0.71 plus.minus script(2.2e-5)$],[$0.72 plus.minus script(5.5e-5)$],[],
  [*F1*], [$0.66 plus.minus script(3.6e-5)$],[$0.67 plus.minus script(9.9e-6)$],[],
  [*Precision*], [$0.68 plus.minus script(3.8e-5)$],[$0.66 plus.minus script(6.7e-6)$],[],
  [*Specificity*], [$0.66 plus.minus script(3.5e-5)$],[$0.68 plus.minus script(3.3e-5)$],[],
),
caption: [Performance Metrics of the #abbr.a[FNN] model. We provide the mean over the 20 runs and the variance]
)<fnn-resutls-table>

@roc-fnn shows the ROC curve of the best performed #abbr.a[FNN] model in the 20 runs for $k=3$. This visualization provides insight into the classification behavior of a single run, we emphasize that the average metrics over multiple runs are used for formal model comparison, as discussed in Section @results-ai.
#figure(image("images/test_roc_fnn_cluster3.png", width: 50%),
caption: [ROC curve for the best-performing #abbr.a[FNN] model (cluster size = 3) across 20 runs, selected based on highest AUC score.])<roc-fnn>