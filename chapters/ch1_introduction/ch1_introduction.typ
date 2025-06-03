#import "@preview/abbr:0.2.3"
= Introduction TODO DONE WITH CHATGPT IMPROVEEEEEEEEE JUST A IDEA

== Motivation
In a rapidly changing world where ecological awareness is more crucial than ever, the aim is to leverage the latest technologies to contribute positively to the environment. While many people use generative AI for entertainment or convenience—such as creating humorous images or drafting emails—thus indirectly accelerating climate change through increased energy consumption, this thesis seeks to utilize artificial intelligence to serve a more meaningful purpose: to detect and warn about emerging threats and damages caused by environmental and climatic changes. 

In this thesis, we explore the application of modern deep learning techniques to the problem of storm damage forecasting. Specifically, we aim to predict whether a given week in a specific geographic region is likely to experience storm-related damage, based solely on weather data. Unlike traditional approaches that rely on handcrafted rules or simulations, our method investigates the predictive capacity of data-driven models trained directly on historical records.

Additionally, this work addresses a notable research gap: to the best of our knowledge, no prior studies have applied advanced deep learning architectures—such as LSTM and Transformer networks—to this specific damage dataset. As such, our goal is not only to evaluate the feasibility of forecasting storm damage from meteorological inputs, but also to establish a strong and reproducible baseline that can serve as a reference point for future research in this underexplored area.

== Work Outline
The objective of this project is to establish a baseline and explore initial steps toward predicting or forecasting environmental damage. As outlined throughout this thesis, numerous geological processes and a range of influencing factors would typically require in-depth expertise in geology—areas that were deliberately excluded to keep the scope at a foundational level. Instead, the focus was placed on weather data as a key influencing factor, while the primary data source for recorded damages consisted of reports published in regional and local newspapers. Various deep learning approaches, differing in complexity and methodology, were applied to assess how weather data may offer initial insights and help identify which predictive strategies warrant further exploration in future research.

To achieve this, we:

- Construct a preprocessing and clustering pipeline that aggregates weather and damage data at weekly resolution and groups locations using K-means clustering
- Train and compare three neural network architectures of increasing complexity: a #abbr.a[FNN] as a baseline, a #abbr.a[LSTM] to capture short-term temporal dependencies, and a Transformer model to investigate the benefits of long-range attention mechanisms
- Evaluate the performance of each model across different levels of spatial granularity (using cluster counts $k in {3, 6, 26}$) and report average metrics across multiple training runs to account for variance and ensure reproducibility
- Develop a prototype software application that visualizes predictions and demonstrates how such a model could be deployed in practice.

The outcomes of this thesis serve two key purposes: 
  - First, to empirically assess the predictive power of deep learning architectures in the context of storm damage 
  - Second, to provide a modular and extensible framework that future researchers and practitioners can build upon.