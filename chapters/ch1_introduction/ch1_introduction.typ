#import "@preview/abbr:0.2.3"
= Introduction  
The objective of this project is to explore initial steps toward predicting or forecasting environmental damage. While environmental damage often involves complex geological interactions, this thesis focuses exclusively on meteorological factors to maintain a manageable scope. The analysis centers on weather data, with damage records extracted from regional newspaper reports. We applied three deep learning models: a #abbr.a[FNN], a #abbr.a[LSTM], and a Transformer, to evaluate how weather patterns relate to reported storm damage and assess the feasibility of data-driven forecasting.

To achieve this, we:

- Construct a preprocessing pipeline that aggregates weather and damage data at weekly resolution and applies K-means clustering to group spatial locations.
- Train and compare three neural network architectures of increasing complexity: a #abbr.a[FNN] as a baseline, a #abbr.a[LSTM] to capture short-term temporal dependencies, and a Transformer model to investigate the benefits of long-range attention mechanisms.
- Evaluate the performance of each model across different levels of spatial granularity (using cluster counts $k in {3, 6, 26}$) and report average metrics across multiple training runs to account for variance and ensure reproducibility
- Develop a software application that visualizes predictions and demonstrates how such a model could be deployed in practice.

This thesis serves two purposes: to empirically evaluate deep learning methods for storm damage forecasting, and to provide a extensible framework for future research.