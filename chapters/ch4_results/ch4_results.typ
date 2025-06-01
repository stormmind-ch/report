#import "@preview/abbr:0.2.3"
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

= Results
This chapter presents the outcomes of both the deep learning experiments and the software engineering components developed during this project. Together, these results address the overarching research goal: to build a reliable and interpretable system for binary storm damage forecasting, supported by a user-oriented software solution.

The first part of this chapter focuses on the quantitative evaluation of machine learning models, where different deep learning architectures were compared with respect to their predictive performance on temporally and spatially structured weather data. These results provide empirical insight into how model complexity and spatial clustering affect classification accuracy and robustness under real-world forecasting conditions.

The second part of this chapter presents the outcomes of the software engineering effort. It details the implementation of the system's user interface and back-end components, designed to support decision-making and visualization for storm damage predictions. We report the results of functional testing, performance measurements, and usability considerations for the final application.

By combining rigorous model evaluation with software, this chapter demonstrates both the predictive capabilities and the practical deployment potential of the proposed solution.

== Results of AI Engineering<results-ai>
The following section presents the results of our comparative evaluation of three deep learning architectures—#abbr.a[FNN], #abbr.a[LSTM], and Transformer—applied to the task of binary storm damage forecasting. This experimental block aims to answer three key questions:
-  Which architecture achieves the best performance on the held out test set?
- Does increased model complexity (e.g., through temporal modeling in LSTM or long-range dependency modeling in Transformers) lead to better forecasting performance compared to the baseline #abbr.a[FNN]?
- How does spatial granularity, operationalized via cluster sizes $k in {3, 6}$, affect model performance? 

To assess these dimensions, each model was trained independently on datasets grouped by different cluster counts. For every architecture–cluster configuration, we performed 20 independent training runs to capture the effects of stochasticity in optimization and initialization.

To ensure statistically robust comparisons, we report the mean and variance of all evaluation metrics across the 20 independent runs, following the best practices recommended in X. Bouthillier et. Al. "Accounting for Variance in Machine Learning Benchmarks" @bouthillierAccountingVarianceMachine2021. For inter-model comparison, we primarily use the macro-averaged F1 score on the test set, as summarized in @model-comparison-to-cluster. This metric is particularly appropriate given the class imbalance described in @data, as it gives equal importance to both classes. Since the minority class (damage) represents the critical target, macro-F1 is better suited than accuracy alone. Additional metrics, including accuracy, AUC, precision, recall, and specificity, are discussed in detail in the model-specific result subsections.

*TODO add rest of the values*
#figure(table(
  columns: 5,

  table.header( [*Clusters*], [*3*],[*4*], [*5*], [*6*]),
   align: center,
  [*#abbr.a[FNN]*], [$0.66 plus.minus script(3.6e-5)$],[$0.65 plus.minus script(0.0039)$],[],[],
  [*#abbr.a[LSTM]*],[],[],[],[],
  [*Transformer*],[$0.65 plus.minus script(0.0048)$],[],[],[],
),
caption: [Average test accuracy and variance for each model across different spatial cluster configurations.Each value represents the mean F1-score over 20 independent training runs, with the corresponding variance shown. Results are grouped by the number of spatial clusters $k in {3,4,5,6}$ used during data preparation.]
)<model-comparison-to-cluster>

#include "sub1_fnn.typ"
#include "sub2_lstm_nn.typ"
#include "sub3_transformer.typ"


== Conclusion

== Software Results


