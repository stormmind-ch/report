#import "../../abbr-impl.typ"
#import "../../abbr.typ"
= Introduction  
The objective of this project is to explore initial steps toward predicting or forecasting storm damages. While environmental damage often involves complex geological interactions, this thesis focuses exclusively on meteorological factors to maintain a manageable scope. The analysis centers on weather data, with damage records extracted from regional newspaper reports. We applied three deep learning models: a #abbr.a[FNN], a #abbr.a[LSTM], and a Transformer, to evaluate how weather patterns relate to reported storm damage and assess the feasibility of data-driven forecasting.

To achieve this, we:

- Constructed a preprocessing pipeline that aggregates weather and damage data at weekly resolution and applies K-means clustering to group spatial locations.
- Trained and compare three neural network architectures of increasing complexity: a #abbr.a[FNN] as a baseline, a #abbr.a[LSTM] to capture short-term temporal dependencies, and a Transformer model to investigate the benefits of long-range attention mechanisms.
- Evaluated the performance of each model across different levels of spatial granularity (using cluster counts $k in {3, 6, 26}$) and presented average metrics across multiple training runs to account for variance and ensure reproducibility.
- Developed a software application that visualizes predictions and demonstrates how such a model could be applied in practice.

This thesis serves two purposes: to empirically evaluate deep learning methods for storm damage forecasting, and to provide an extensible framework for future research.
#pagebreak()
== Comparable projects<compareable-projects>
The following projects demonstrate how #abbr.a[AI] is being applied in practice to address specific natural hazard challenges, from storm damage assessment to avalanche forecasting.

Swiss Re's #abbr.a[RDA] leverages deep learning algorithms alongside existing #abbr.a[NatCat] models, satellite imagery, weather, and property data to:
- assess the damage potential to properties
- prioritize property inspections following an event
- analyze property impacts to generate reports

Currently, the system is available only for tropical cyclones, tornadoes, and hailstorms in the US. However, there are plans to expand it to additional perils within the US and to extend coverage to other countries. @SwissReRapid2025

RAvaFcast v1.0.0 @RAvaFcastKunstlicheIntelligenz is an #abbr.a[AI] system designed to improve avalanche prediction in high-risk regions in Switzerland. The research is based on historical avalanche records and weather data. The approach follows a three-stage model pipeline consisting of classification, interpolation, and aggregation. Evaluation results demonstrated a strong correlation between model predictions and human expert assessments. @maissenThreestageModelPipeline2024