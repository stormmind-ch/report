#import "@preview/abbr:0.2.3"
#import "@preview/abbr:0.2.3"
= Methodology

== AI Engineering

=== Data<data>

The basis of the data was provided by the #abbr.a[WSL]. The correspondence partner was K. Liechti, who provided valuable insights into the data as well as into the relevant geographical and meteorological processes.
To comply with the legal restrictions cited in @disclaimer, the use of #abbr.pla[WSL] data in this thesis was limited. These limitations ultimately proved beneficial to the modeling process, as demonstrated by the experiments.

The sources for the recorded incidents were Swiss newspapers. As a result, the accuracy of the incident locations cannot be guaranteed, and the (financial) extent of the damages is only an approximation. In some cases, the location could not be precisely determined; thus, only the region or canton was recorded. Due to these uncertainties, the financial extent had to be rounded, and the damages grouped by canton or region prior to publication.

As outlined in @weather-features, the scope of the dataset was extensive. The features selected for this thesis were limited to the following: “Gemeindenamen”, “Datum”, “Hauptprozess”, and “Schadensausmass”, which were identified as the most relevant variables related to damage.

Based on the inputs of K. Liechti, the relevant meteorological variables were identified as sunshine duration, ground temperature, snowfall, and rainfall.\ 
The rationale for this selection is briefly summarized below; detailed explanations can be found in @weather-research:\
Sunshine hours influence ground temperature, which in turn can cause snowmelt or thaw ground frost.\
Ground temperature was not available via open-meteo@zippenfenigOpenMeteocomWeatherAPI2023; therefore, the temperature at 2 meters above ground was used as a proxy.\
Snowfall can contribute to snowmelt processes later in the seasonal cycle.\
Rainfall directly contributes to the potential for flooding and can also indirectly increase ground temperature.\

Continuous experimentation with the collected data has yielded several useful insights. The proportion of damage-related entries (28,515) compared to the total number of entries (approximately 52 million — the Cartesian product of all days between 01.01.1970 and 31.12.2023 with all municipalities) is highly imbalanced.  

Techniques such as downsampling and upsampling were evaluated, but due to the time-series nature of the data, these methods did not produce any meaningful improvements. An alternative approach — which also helps anonymize the data — was to apply k-means clustering based on geographic coordinates and to aggregate the recorded damages per cluster per week.  

In a subsequent experiment/*@fnn_experiment*/, snowfall was found to have no significant impact and was therefore completely removed from the dataset.

=== Data Cleaning

The damage data referenced in @data required several processing steps before it could be used in the modeling phase.
As noted in @disclaimer, the municipality names correspond to the administrative boundaries of 1996 and are thus not up to date. To identify outdated names, GPS coordinates were retrieved using the Geocoding API @OpenCageEasyOpen. For approximately 300 out of 2759 municipalities, no coordinates could be retrieved. Manual analysis of these cases revealed recurring issues.

For some incidents, as described in @data, #abbr.s[WSL] could not determine the exact location and had to assign them to a canton (30 of 28,515 cases), region (3), or district (10). Due to their low frequency, these entries were excluded from the dataset.

Common abbreviations used in the #abbr.pla[WSL] dataset—such as “a.A.” for “am Albis” or “St.” for “Sankt”—were standardized.
Additionally, some municipalities had been merged into others since 1996. These cases were manually updated with their current names.

The weather data required less preprocessing. In eight municipalities, occasional values were set to 'null' (no data available); these were replaced by 0.

=== Availability of Sources and Data Collection<aosadc>

The data currently in use was collected with relatively little difficulty. The damage data was kindly provided by K. Liechti from the #abbr.a[WSL] following a formal request via email @liechtiREAnfrageZur2024.

For the collection of weather data, the initial approach was to use official government data provided by MeteoSwiss @MeteoSwissIDAWEBLogin. However, due to the structure of the website and the raw nature of the station-based measurement data, this approach was ultimately abandoned.  
During further research, the open-meteo API @zippenfenigOpenMeteocomWeatherAPI2023 was discovered. To avoid excessive costs, a free academic access key was requested and kindly provided @zippenfenigProfessionalAPIKey.

To obtain information on soil conditions, the first resource consulted was the Swiss federal geoportal map.geo.admin @MapsSwitzerlandSwiss. However, the format of the data was mostly incompatible with the tools available for this thesis.  
An alternative considered was the GIS Browser @GISBrowserGeoportalKanton, which is the cantonal equivalent of map.geo.admin @MapsSwitzerlandSwiss. Unfortunately, it posed the same limitations as the federal source.

Given that new buildings are constantly being constructed in Switzerland and that the Swiss Confederation is actively researching locations for a nuclear waste repository @VergrabenUndVergessen2019, it was assumed that public institutions must maintain relevant geotechnical data.

First, the building construction office of Affoltern am Albis was contacted @duchaudPhoneCallHochbau2025. They referred the inquiry to the cantonal building construction office, which also denied possession of such data and redirected the request to the Office for Spatial Development @PhoneCallHochbau2025.

The contact person from the Office for Spatial Development @muellerPhoneCallAmt2025 was likewise unable to provide relevant data or further contacts. Their suggestion was to consult the GIS Browser @GISBrowserGeoportalKanton or map.geo.admin @MapsSwitzerlandSwiss.  

After these repeated unsuccessful attempts, the GIS Helpdesk was contacted @ueltschiBodenbeschaffenheitskarte. The proposed solution @fachstellegisAREJIRAGIS2262EXTERN was again to use the GIS Browser or map.geo.admin, which had already proven inadequate.  
Due to time constraints, this approach was ultimately abandoned.

=== Deep Learning Experiments <experiemnt-set-up>
#include "sub1_deep_learning_experiments.typ"

== Software Engineering

=== Backend

==== Technologies

==== Architecture

=== Frontend

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

The Frontend consists of a react/vite repository. The DNS Entree was made on Hosttech and references an instance on the Openstack cluster of ZHAW @LoginOpenStackDashboard

=== Test Concept