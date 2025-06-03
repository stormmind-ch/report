#import "@preview/abbr:0.2.3"
= Introduction  
The objective of this project is to explore initial steps toward predicting or forecasting environmental damage. While environmental damage often involves complex geological interactions, this thesis focuses exclusively on meteorological factors to maintain a manageable scope. The analysis centers on weather data, with damage records extracted from regional newspaper reports. We applied three deep learning models: a #abbr.a[FNN], a #abbr.a[LSTM], and a Transformer, to evaluate how weather patterns relate to reported storm damage and assess the feasibility of data-driven forecasting.

To achieve this, we:


- Construct a preprocessing pipeline that aggregates weather and damage data at weekly resolution and applies K-means clustering to group spatial locations.
- Train and compare three neural network architectures of increasing complexity: a #abbr.a[FNN] as a baseline, a #abbr.a[LSTM] to capture short-term temporal dependencies, and a Transformer model to investigate the benefits of long-range attention mechanisms.
- Evaluate the performance of each model across different levels of spatial granularity (using cluster counts $k in {3, 6, 26}$) and report average metrics across multiple training runs to account for variance and ensure reproducibility
- Develop a software application that visualizes predictions and demonstrates how such a model could be deployed in practice.

== Motivation
In a rapidly changing world where ecological awareness is more crucial than ever, the aim is to leverage the latest technologies to contribute positively to the environment. While many people use generative AI for entertainment or convenience—such as creating humorous images or drafting emails—thus indirectly accelerating climate change through increased energy consumption, this thesis seeks to utilize artificial intelligence to serve a more meaningful purpose: to detect and warn about emerging threats and damages caused by environmental and climatic changes. 



== Work Outline
The objective of this project is to establish a baseline and explore initial steps toward predicting or forecasting environmental damage. As outlined throughout this thesis, numerous geological processes and a range of influencing factors would typically require in-depth expertise in geology—areas that were deliberately excluded to keep the scope at a foundational level. Instead, the focus was placed on weather data as a key influencing factor, while the primary data source for recorded damages consisted of reports published in regional and local newspapers. Various deep learning approaches, differing in complexity and methodology, were applied to assess how weather data may offer initial insights and help identify which predictive strategies warrant further exploration in future research.

== Comparable projects

*Swiss Re*'s #abbr.a[RDA] leverages deep learning algorithms alongside existing #abbr.a[NatCat] models, satellite imagery, weather, and property data to:
- assess the damage potential to properties
- prioritize property inspections following an event
- analyze property impacts to generate reports

Currently, the system is available only for tropical cyclones, tornadoes, and hailstorms in the US. However, there are plans to expand it to additional perils within the US and to extend coverage to other countries. @SwissReRapid2025

*RAvaFcast v1.0.0* @RAvaFcastKunstlicheIntelligenz is an artificial intelligence system designed to improve avalanche prediction in high-risk regions in Switzerland. The research was based on historical avalanche records and weather data. The approach follows a three-stage model pipeline consisting of classification, interpolation, and aggregation. Evaluation results demonstrated a strong correlation between model predictions and human expert assessments. @maissenThreestageModelPipeline2024


This thesis serves two purposes: to empirically evaluate deep learning methods for storm damage forecasting, and to provide a extensible framework for future research.