#import "../../abbr-impl.typ"
#import "../../abbr.typ"
//SETTINGS:
#show table.cell.where(y: 0): strong
#set table(
  stroke: (x, y) => if y == 0 {
    (bottom: 0.7pt + black)
  },
  align: (x, y) => (
    if x > 0 { center }
    else { left }
  )
)

= Results<results-ai>

The following section presents the results of our comparative evaluation of three deep learning architectures, #abbr.a[FNN], #abbr.a[LSTM], and Transformer, applied to the task of binary storm damage forecasting. The inter-model comparison is summarized in @experiment-1 and @experiment-2. Detailed results for each architecture are provided in their respective subsections. 

This section aims to answer three key questions:
1.  Which architecture achieves the best performance on the held out test set?
2. Does increased model complexity (e.g., through temporal modeling in LSTM or long-range dependency modeling in Transformers) lead to better forecasting performance compared to the baseline #abbr.a[FNN]?
3. How does spatial granularity, implemented through cluster sizes $k in {3, 6}$, affect model performance? 3 and 6 were chosen as number of clusters due to the highest decreasing within sum of cluster centroid as described in @data. 
Additionally, we conducted an experiment with $k = 26$ clusters to evaluate model performance at a finer spatial granularity. The results are presented in @experiment-2.

#pagebreak()

== Experiment 1<experiment-1>
To ensure statistically robust comparisons, we report the mean and variance of all evaluation metrics across the 3 best runs over the 20 independent runs, following the best practices recommended in X. Bouthillier et. Al. "Accounting for Variance in Machine Learning Benchmarks" @bouthillierAccountingVarianceMachine2021. The reason for only choosing the top 3 runs per model and cluster, is to eliminate any negative outliers. We are more interested in what the model is capable to do in its best configuration, rather than accounting for worse configurations.
For inter-model comparison, we primarily use the macro-averaged F1-score on the test set, as summarized in @model-comparison-to-cluster-3-6. This metric is particularly appropriate given the class imbalance described in @data, as it gives equal importance to both classes. Since the minority class (damage) represents the critical target, macro-F1 is better suited than accuracy alone. Additional metrics, including accuracy, AUC, precision, recall, and specificity, are discussed in detail in the model-specific result subsections.
#figure(table(
  columns: 3,

  table.header( [*Clusters*], [*3*],[*6*]),
   align: center,
  [*#abbr.s[FNN]*], [$0.67 plus.minus script(9.5e-6)$],[$0.67 plus.minus script(9.9e-6)$],
  [*#abbr.s[LSTM]*],[$0.67 plus.minus script(2.2e-6)$],[$0.65 plus.minus script(3e-7)$],
  [*Transformer*],[$0.68 plus.minus script(1.4e-6)$],[$0.67 plus.minus script(7.9e-8)$]
),
caption: [Average test macro F1-score and variance for each model across different spatial cluster configurations.Each value represents the mean F1-score over the top 3 runs from the  20 independent training runs, with the corresponding variance shown. Results are grouped by the number of spatial clusters $k in {3, 6}$ used during data preparation.]
)<model-comparison-to-cluster-3-6>

@model-comparison-to-cluster-3-6 shows that the Transformer model achieved the highest macro-averaged F1-score with $k = 3$ clusters, outperforming both the #abbr.a[FNN] and #abbr.a[LSTM] models. In addition to achieving the best score, the Transformer also exhibited the lowest variance among the top 3 runs, indicating greater consistency and stability in performance. This suggests that the attention-based architecture is better suited for capturing the patterns necessary for storm damage prediction in this setup.

Interestingly, the #abbr.a[LSTM] model performed worse than the simpler #abbr.a[FNN], particularly for $k = 6$. This finding implies that increased model complexity—through sequence modeling—does not necessarily lead to better performance in this case. One possible explanation is that the temporal dependencies in the input data are either too weak or too noisy for the LSTM to leverage effectively.

#pagebreak()

== Experiment 2<experiment-2>
This subsection presents the results of a finer-grained experimental setup using $k = 26$ clusters. The choice of $k = 26$ was motivated by the number of cantons in Switzerland. However, it is important to note that the resulting clusters do not precisely correspond to canton boundaries, as municipalities were grouped using the K-means algorithm (see @data_preparation).

The experimental procedure was identical to that of Experiment 1 (@experiment-1), with the exception that only 6 runs were performed instead of 20. This reduction was due to computational constraints.

The results for all models in this configuration are summarized in @model-comparison-26.

#figure(table(
  columns: 2,
  table.header([*Model*], [*F1-Score*]), 
  align: center,
  [*#abbr.a[FNN]*], [$0.66 plus.minus script(2.6e-6)$],
  [*#abbr.a[LSTM]*], [$0.6 plus.minus script(5.5e-5)$],
  [*Transformer*], [$0.57 plus.minus script(0.0056)$],
),
caption: [Average test macro F1-score and variance for each model.Each value represents the mean F1-score over the top 3 runs from the  6 independent training runs, with the corresponding variance shown.])<model-comparison-26>

In this experiment, the #abbr.a[FNN] outperformed both the #abbr.a[LSTM] and Transformer models. This result may reflect the limited number of training runs available for hyperparameter optimization. During prior experiments, the #abbr.a[LSTM] and Transformer models required substantially more sweep iterations to converge on high-performing configurations, whereas the #abbr.a[FNN] typically reached optimal settings with fewer trials.

Therefore, the results in this section should be interpreted with caution. Rather than indicating a fundamental advantage of the #abbr.a[FNN] at higher spatial granularity, the outcome likely reflects an underexploration of the hyperparameter space for the more complex models. As such, this experiment should be viewed as a preliminary probe for future research rather than a conclusive benchmark.
#pagebreak()
== In depth model analysis
To complement the macro-F1 comparison, we provide a detailed breakdown of additional performance metrics, accuracy, AUC, precision, and specificity, for all models across the three spatial configurations ($k in {3, 6, 26}$). The following table summarizes the results:
#figure(table(
  columns: 5,
  align: center,

  [*Metric*], [*#abbr.a[FNN]*], [*#abbr.a[LSTM]*], [*Transformer*], [*Cluster*],

  [*Accuracy*], [$67.55% plus.minus script(0.35)$], [$68.41% plus.minus script(0.02)$], [$68.14% plus.minus script(0.00)$], [$3$],
  [], [$70.68% plus.minus script(0.56)$], [$69.25% plus.minus script(0.44)$], [$70.25% plus.minus script(0.00)$], [$6$],
  [], [$67.99% plus.minus script(0.00)$], [$72.54% plus.minus script(1.68)$], [$79.26% plus.minus script(57.97)$], [$26$], table.hline(),

  [*AUC*], [$0.71 plus.minus script(2.2e-5)$], [$0.71 plus.minus script(2.4e-8)$], [$0.72 plus.minus script(9.6e-5)$], [$3$],
  [], [$0.72 plus.minus script(5.5e-5)$], [$0.71 plus.minus script(1.9e-5)$], [$0.74 plus.minus script(6.2e-6)$], [$6$],
  [], [$0.71 plus.minus script(2.7e-7)$], [$0.76 plus.minus script(1.9e-5)$], [$0.69 plus.minus script(0.024)$], [$26$], table.hline(),

  [*F1-score*], [$0.66 plus.minus script(3.6e-5)$], [$0.67 plus.minus script(2.2e-6)$], [$0.68 plus.minus script(1.4e-6)$], [$3$],
  [], [$0.67 plus.minus script(9.9e-6)$], [$0.65 plus.minus script(3e-7)$], [$0.67 plus.minus script(7.9e-8)$], [$6$],
  [], [$0.66 plus.minus script(2.6e-6)$], [$0.60 plus.minus script(5.5e-5)$], [$0.57 plus.minus script(0.0056)$], [$26$], table.hline(),

  [*Precision*], [$0.68 plus.minus script(3.8e-5)$], [$0.68 plus.minus script(9.1e-6)$], [$0.68 plus.minus script(4.6e-7)$], [$3$],
  [], [$0.66 plus.minus script(6.7e-6)$], [$0.65 plus.minus script(1.6e-6)$], [$0.66 plus.minus script(9.5e-8)$], [$6$],
  [], [$0.66 plus.minus script(2.4e-6)$], [$0.60 plus.minus script(6.2e-6)$], [$0.63 plus.minus script(0.00061)$], [$26$], table.hline(),

  [*Specificity*], [$0.66 plus.minus script(3.5e-5)$], [$0.67 plus.minus script(1.5e-6)$], [$0.67 plus.minus script(2.9e-6)$], [$3$],
  [], [$0.68 plus.minus script(3.3e-5)$], [$0.67 plus.minus script(3.6e-5)$], [$0.69 plus.minus script(1.8e-6)$], [$6$],
  [], [$0.67 plus.minus script(6e-6)$], [$0.71 plus.minus script(8.9e-7)$], [$0.65 plus.minus script(0.015)$], [$26$],
),
caption: [Detailed performance metrics for all three models across different spatial cluster configurations. Values represent the mean and variance over the top 3 runs per setting. For $k = 26$, only 6 runs were performed due to compute limitations.]
)<combined-model-metrics>

Across all metrics except accuracy, the Transformer model consistently achieved the highest values for cluster sizes 3 and 6. Higher F1-scores and AUC values, indicating its superior ability to capture relevant temporal and spatial patterns. Its low variance across runs suggests a robust and stable learning process.

The #abbr.a[FNN] model—despite its simplicity—remained competitive across configurations, especially for $k = 6$, where it outperformed the #abbr.a[LSTM] in both F1-score and AUC. Precision remained strong and stable, but the increasing accuracy with higher $k$ values may reflect an inflation due to class imbalance, favoring the dominant no-damage class.

The #abbr.a[LSTM] model showed mixed results. Although designed to model sequential dependencies, it underperformed in terms of F1-score at $k = 6$ and significantly dropped at $k = 26$, where class imbalance and limited training data per cluster likely reduced the ability to generalize. However, the #abbr.a[LSTM] achieved the highest AUC at $k = 26$, suggesting some ability to separate the classes.

Specificity generally increased with cluster count across all models, while precision slightly declined—further supporting the hypothesis that finer-grained clusters increase class imbalance and challenge the models’ ability to detect true positives.



== Key Findings and Interpretation

This section summarizes the key findings in direct response to the research questions outlined at the beginning of the results chapter.

1. The Transformer consistently achieved the highest macro-averaged F1-scores across the cluster configurations $k in {3, 6\}$. While the performance gains were modest, the Transformer outperformed both the #abbr.a[FNN] and the #abbr.a[LSTM] models, indicating its superior capability in capturing relevant patterns for storm damage forecasting.
2. Increased complexity did not uniformly translate into better performance. The #abbr.a[LSTM], although more complex than #abbr.a[FNN], performed worse in several configurations. In contrast, the Transformer, which introduces even greater complexity, demonstrated slight but consistent improvements over both #abbr.a[FNN] and #abbr.a[LSTM]. This suggests that not all forms of complexity are equally beneficial, and that architectural innovations like attention may offer more value than merely increasing parameter count or depth.
3. Model performance tended to decline slightly as the number of spatial clusters increased. This may be attributed to increased class imbalance at finer granularity, where the proportion of “no-damage” samples rises, making storm damage harder to detect.

In summary, while the Transformer emerged as the most effective model for $k = 3$ and $k = 6$, its advantage over the simpler #abbr.a[FNN] was relatively small. This makes the #abbr.a[FNN] a strong candidate for practical applications requiring lower computational overhead. At the same time, the success of the Transformer supports further exploration of self-attention mechanisms for this forecasting task.
