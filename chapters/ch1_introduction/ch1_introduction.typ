#import "@preview/abbr:0.2.3"
= Introduction TODO DONE WITH CHATGPT IMPROVEEEEEEEEE JUST A IDEA

== Motivation

The increasing frequency and severity of extreme weather events—particularly storms—pose a growing threat to infrastructure, public safety, and economic stability. Anticipating the potential impact of such events is therefore of great practical importance, especially for early-warning systems, insurance providers, and emergency response coordination. While meteorological forecasting has seen significant progress in recent years, translating raw weather data into actionable predictions of storm-related damage remains a challenging task.

In this thesis, we explore the application of modern deep learning techniques to the problem of storm damage forecasting. Specifically, we aim to predict whether a given week in a specific geographic region is likely to experience storm-related damage, based solely on weather data. Unlike traditional approaches that rely on handcrafted rules or simulations, our method investigates the predictive capacity of data-driven models trained directly on historical records.

Additionally, this work addresses a notable research gap: to the best of our knowledge, no prior studies have applied advanced deep learning architectures—such as LSTM and Transformer networks—to this specific damage dataset. As such, our goal is not only to evaluate the feasibility of forecasting storm damage from meteorological inputs, but also to establish a strong and reproducible baseline that can serve as a reference point for future research in this underexplored area.

== Work Outline

This thesis is structured around the development, training, and evaluation of several deep learning models for binary classification of storm damage events based on weekly aggregated weather features. The central task is to predict whether storm-related damage will occur in a given week and region, using input variables such as temperature, rainfall, and sunshine duration.

To achieve this, we:

- Construct a preprocessing and clustering pipeline that aggregates weather and damage data at weekly resolution and groups locations using K-means clustering
- Train and compare three neural network architectures of increasing complexity: a #abbr.a[FNN] as a baseline, a #abbr.a[LSTM] to capture short-term temporal dependencies, and a Transformer model to investigate the benefits of long-range attention mechanisms
- Evaluate the performance of each model across different levels of spatial granularity (using cluster counts $k in {3, 6, 26}$) and report average metrics across multiple training runs to account for variance and ensure reproducibility
- Develop a prototype software application that visualizes predictions and demonstrates how such a model could be deployed in practice.

The outcomes of this thesis serve two key purposes: 
  - First, to empirically assess the predictive power of deep learning architectures in the context of storm damage 
  - Second, to provide a modular and extensible framework that future researchers and practitioners can build upon.