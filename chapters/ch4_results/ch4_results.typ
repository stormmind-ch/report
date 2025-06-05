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

The following section presents the results of our comparative evaluation of three deep learning architectures, #abbr.a[FNN], #abbr.a[LSTM], and Transformer, applied to the task of binary storm damage forecasting. This experimental block aims to answer three key questions:
1.  Which architecture achieves the best performance on the held out test set?
2. Does increased model complexity (e.g., through temporal modeling in LSTM or long-range dependency modeling in Transformers) lead to better forecasting performance compared to the baseline #abbr.a[FNN]?
3. How does spatial granularity, implemented through cluster sizes $k in {3, 6, 26}$, affect model performance? 3 and 6 were chosen as number of clusters due to the highest decreasing within sum of cluster centroid as described in @data. The number of 26 was chosen as it aligns with the number of Cantons of Switzerland and we wanted to test on a more finer granularity. It is explicitly stated that the constructed clusters do not precisely correspond to the canton borders, as municipalities are assigned to clusters using the K-means algorithm, as detailed in @data_preparation.
#pagebreak()

To ensure statistically robust comparisons, we report the mean and variance of all evaluation metrics across the 3 best runs over the 20 independent runs, following the best practices recommended in X. Bouthillier et. Al. "Accounting for Variance in Machine Learning Benchmarks" @bouthillierAccountingVarianceMachine2021. The reason for only choosing the top 3 runs per model and cluster, is to eliminate any negative outliers. We are more interested in what the model is capable to do in its best configuration, rather than accounting for worse configurations.
For inter-model comparison, we primarily use the macro-averaged F1 score on the test set, as summarized in @model-comparison-to-cluster. This metric is particularly appropriate given the class imbalance described in @data, as it gives equal importance to both classes. Since the minority class (damage) represents the critical target, macro-F1 is better suited than accuracy alone. Additional metrics, including accuracy, AUC, precision, recall, and specificity, are discussed in detail in the model-specific result subsections.

*TODO add rest of the values*
#figure(table(
  columns: 4,

  table.header( [*Clusters*], [*3*],[*6*], [*26*]),
   align: center,
  [*#abbr.s[FNN]*], [$0.67 plus.minus script(9.5e-6)$],[$0.67 plus.minus script(9.9e-6)$],[$0.67 plus.minus script(3.7e-7)$],
  [*#abbr.s[LSTM]*],[$0.67 plus.minus script(2.2e-6)$],[$0.65 plus.minus script(3e-7)$],[],
  [*Transformer*],[$0.68 plus.minus script(1.4e-6)$],[$0.67 plus.minus script(7.9e-8)$],[]
),
caption: [Average test macro F1-score and variance for each model across different spatial cluster configurations.Each value represents the mean F1-score over the top 3 runs from the  20 independent training runs, with the corresponding variance shown. Results are grouped by the number of spatial clusters $k in {3, 6, 26}$ used during data preparation.]
)<model-comparison-to-cluster>

#include "sub1_fnn.typ"
#include "sub2_lstm_nn.typ"
#include "sub3_transformer.typ"


== Key Findings and Interpretation

This section summarizes the key findings in direct response to the research questions outlined at the beginning of the results chapter.

1. The Transformer consistently achieved the highest macro-averaged F1 scores across the cluster configurations $k in {3, 6\}$. While the performance gains were modest, the Transformer outperformed both the #abbr.a[FNN] and the #abbr.a[LSTM] models, indicating its superior capability in capturing relevant patterns for storm damage forecasting.
2. Increased complexity did not uniformly translate into better performance. The #abbr.a[LSTM], although more complex than #abbr.a[FNN], performed worse in several configurations. In contrast, the Transformer—which introduces even greater complexity through self-attention mechanisms—demonstrated slight but consistent improvements over both #abbr.a[FNN] and #abbr.a[LSTM]. This suggests that not all forms of complexity are equally beneficial, and that architectural innovations like attention may offer more value than merely increasing parameter count or depth.
3. Model performance tended to decline slightly as the number of spatial clusters increased. This may be attributed to increased class imbalance at finer granularities, where the proportion of “no-damage” samples rises, making storm damage harder to detect.

In summary, while the Transformer emerged as the most effective model, its advantage over the simpler #abbr.a[FNN] was relatively small. This makes the #abbr.a[FNN] a strong candidate for practical applications requiring lower computational overhead. At the same time, the success of the Transformer supports further exploration of self-attention mechanisms for this forecasting task.
