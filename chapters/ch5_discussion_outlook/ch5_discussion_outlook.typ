#import "../../abbr-impl.typ"
#import "../../abbr.typ"
= Discussion and Outlook


This thesis presents a first step toward Deep Learning-based storm damage forecasting. Although the evaluated models—#abbr.a[FNN], #abbr.a[LSTM], and Transformer—are not yet suitable for real-world deployment, their performance marks an important foundation for future research. The planned demonstration and expert assessment by Liechti, could not be conducted due to her unavailability during the project’s final phase. The final version of this work will be submitted to her for review, with a concluding summary published on _stormmind.ch_. \
All models were trained solely on weather data, yet storm damage depends on a complex interplay of environmental, infrastructural, and geographical factors, many of which were not included in the current modeling approach.
This shortcoming points to a key opportunity for future research: incorporating additional data sources such as vegetation cover, infrastructure types, topography, and soil saturation. We believe that with an expanded feature set and increased domain knowledge, the predictive accuracy of these models can be significantly enhanced.
As discussed in @compareable-projects, major industry players are actively pursuing comparable solutions, underscoring both the relevance and the inherent difficulty of this problem. It is our hope that the methods and insights presented in this thesis will provide a meaningful foundation for future work in this area.
In particular, we see promising potential for collaboration with #abbr.s[WSL], whose datasets and expertise could substantially support continued development. Further data collection and careful feature engineering will be critical in identifying the most predictive variables for storm damage forecasting.
