#import "@preview/abbr:0.2.3"
#import "@preview/abbr:0.2.3"
= Methodology

== AI Engineering

=== Data<data>

The basis of the data was provided by the #abbr.a[WSL]. The correspondence partner was K. Liechti, who provided valuable insights into the data as well as into the relevant geographical and meteorological processes.
To comply with the legal restrictions cited in @disclaimer, the use of #abbr.pla[WSL] data in this thesis was limited. These limitations ultimately proved beneficial to the modeling process, as demonstrated by the experiments.

The sources for the recorded incidents were Swiss newspapers. As a result, the accuracy of the incident locations cannot be guaranteed, and the (financial) extent of the damages is only an approximation. In some cases, the location could not be precisely determined; thus, only the region or canton was recorded. Due to these uncertainties, the financial extent had to be rounded, and the damages grouped by canton or region.

As outlined in @weather-features, the scope of the dataset was extensive. The features selected for this thesis were limited to the following: “Gemeindenamen”, “Datum”, “Hauptprozess”, and “Schadensausmass”, which were identified as the most relevant variables related to damage.

Based on the inputs of K. Liechti, the relevant meteorological variables were identified as sunshine duration, ground temperature, snowfall, and rainfall.\ 
The rationale for this selection is briefly summarized below; detailed explanations can be found in @weather-research:\
Sunshine hours influence ground temperature, which in turn can cause snowmelt or thaw ground frost.\
Ground temperature was not available via open-meteo@zippenfenigOpenMeteocomWeatherAPI2023; therefore, the temperature at 2 meters above ground was used as a proxy.\
Snowfall can contribute to snowmelt processes later in the seasonal cycle.\
Rainfall directly contributes to the potential for flooding and can also indirectly increase ground temperature.\

=== Data Cleaning

The damage data referenced in @data required several processing steps before it could be used in the modeling phase.
As noted in @disclaimer, the municipality names correspond to the administrative boundaries of 1996 and are thus not up to date. To identify outdated names, GPS coordinates were retrieved using the Geocoding API @GeocodingAPIAPI. For approximately 300 out of 2759 municipalities, no coordinates could be retrieved. Manual analysis of these cases revealed recurring issues.

For some incidents, as described in @data, #abbr.s[WSL] could not determine the exact location and had to assign them to a canton (30 of 28,515 cases), region (3), or district (10). Due to their low frequency, these entries were excluded from the dataset.

Common abbreviations used in the #abbr.pla[WSL] dataset—such as “a.A.” for “am Albis” or “St.” for “Sankt”—were standardized.
Additionally, some municipalities had been merged into others since 1996. These cases were manually updated with their current names.

The weather data required less preprocessing. In eight municipalities, occasional values were set to 'null' (no data available); these were replaced by 0.


=== Deep Learning Experiments <experiemnt-set-up>
#include "sub1_deep_learning_experiments.typ"

== Software Engineering

=== Backend

==== Technologies

==== Architecture

=== Fronttend

#figure(
  image("images/web_route_BA_v2.png", width: 100%),
  caption: [
    web routing: created with
    apple freeform, laptop from chatgpt
    (prompt: erstelle mir ein png eines minimalistischen
    laptops ohne hintergrund)

  ],
)

==== Technologies

=== Test Concept