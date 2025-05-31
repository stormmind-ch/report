#import "@preview/abbr:0.2.3"
The underlying data was provided by the #abbr.a[WSL], with Dr. K. Liechti serving as the primary contact. Her contributions offered valuable insights not only into the dataset itself but also into the relevant geographical and meteorological processes.

In accordance with the legal restrictions outlined in @disclaimer—specifically, the rounding of damage values and the aggregation of location data—the use of #abbr.pla[WSL] data in this thesis was subject to certain limitations. Interestingly, these constraints ultimately proved advantageous for the modeling process, as evidenced by the experimental results.

The sources for the recorded incidents were local and regional Swiss newspapers. As a result, the accuracy of the incident locations cannot be guaranteed, and the (financial) extent of the damages is only an approximation. In some cases, the location could not be precisely determined; thus, only the region or canton was recorded. Due to these uncertainties, the financial extent had to be rounded, and the damages grouped by canton or region prior to publication.

As outlined in @weather-features, the scope of the dataset was extensive. The features selected for this thesis were limited to the following: “Gemeindenamen”, “Datum”, “Hauptprozess”, and “Schadensausmass”, which were identified as the most relevant variables related to damage.

Based on the inputs of K. Liechti, the relevant meteorological variables were identified as sunshine duration, ground temperature, snowfall, and rainfall.\ 
The rationale for this selection is briefly summarized below; detailed explanations can be found in @weather-research:\
Sunshine hours influence ground temperature, which in turn can cause snowmelt or thaw ground frost.\
Ground temperature was not available via open-meteo@zippenfenigOpenMeteocomWeatherAPI2023; therefore, the temperature at 2 meters above ground was used as a proxy.\
Snowfall can contribute to snowmelt processes later in the seasonal cycle.\
Rainfall directly contributes to the potential for flooding and can also indirectly increase ground temperature. 

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

=== Data Preparation<data_preparation>
After collecting all relevant datasets, a series of preprocessing steps were applied to construct a complete spatio-temporal dataset suitable for storm damage forecasting.

*Adding  Non-damage Data*: 

The original dataset, discussed in @data provided by #abbr.a[WSL] contained only records of storm damage events, each described by the attributes: Date, Municipality, Main Process, and Extent of Damage. However, to train a forecasting model, it was necessary to include days and locations with no reported damage. Therefore, the dataset was extended by computing the Cartesian product of: 
$ 
  "Dates" times "Municiaplities" 
$ 
Let $D$ denote the set of all the dates from 1972 to 2023 and $M$ the set of all Swiss municiaplities based on the Swiss official commune register @AmtlichesGemeindeverzeichnisSchweiz published in 2013. We constructed: $ X = {(d, m)} | d in D, m in M $ This set was then left-joined with the original storm damage records. For entries where no damage was raported, the fields `Extent of Damage` and `Main Process` were inputed with zeros. Furthermore, due to political changes over the decades (e.g., municipal mergers), all historical municipality names were mapped to their most recent equivalent, based on the Swiss official commune register  @AmtlichesGemeindeverzeichnisSchweiz. As a result, the final base dataset consited of 52,399,36 rows of which:
  - 52'372'088 represented non-damage instances
  - 24'613 corresponded to small damage events
  - 1'800 were classified as medium damage
  - 859 indicated large-scale damages

*Spatial Clustering*: 

To address the extreme class imbalance and to comply with #abbr.pla[WSL] data usage disclaimer (@disclaimer), we aggregated municipalities into $k$ spatial clusters using k-means clustering on geographic coordinates (latitude and longitude). Let $x_i= (lambda_i, phi_i)$ be the coordinates for municipality $i$. The clustering objective was to minimize: 
$
sum_(i=1)^N min_(j in {1 dots k})(norm(x_i - mu_j))^2 
$ @23Clustering
where $mu_j$ denotes the centroid of cluster $j$. This was implemented using the `KMeans` algorithim from SciKitLearn @ScikitlearnMachineLearning. 

To ensure deterministic behavior of the `KMeans` algorithm from SciKitLearn @ScikitlearnMachineLearning, we specified both the random_state parameter and a fixed number of initializations. In particular, we set: `random_state`= $42$ and `n_init` = $10$.  This guarantees that, for a given number of clusters $k$, the clustering results are identical across repeated runs. The random_state controls the random number generation used for centroid initialization, and setting it ensures reproducibility of the clustering outcome. @ScikitlearnMachineLearning @6-clusters presents an illustrative example of the spatial clustering of all municipalities into $k=6$ clusters. 

#figure(
  image("images/kmeans-clusters6-plot.png", width: 60%),
caption: [Example clustering of all Swiss municiaplities with $k=6$. The black crosses indicate the centroids of the respective clusters.]
)<6-clusters>

Determining the optimal number of clusters proved challenging, as no clear "elbow point" could be identified in the curve shown in @elbow-plot. Instead of relying on a single fixed value, we opted to use a range of cluster counts between $k = 3$ and $k = 6$. This range was chosen based on the observation that the within-cluster sum of squares decreases most noticeably in this interval, indicating a diminishing return in compactness beyond six clusters.
#figure(image("images/kmeans-cluster-elbow.png", width: 60%),
caption: [Elbow plot showing the number of clusters on the x-axis and the corresponding within-cluster sum of squares (WCSS) on the y-axis]
)<elbow-plot>

Each damage entry was then aggregated per cluster center and normalized by a weighted sum reflecting the severity of the damage class (small, medium, large). This yielded a dataset with $k$ time series, one for each cluster.

To choose the right size of clusters, we used the "Elbow Method" 

*Temporal Grouping*: 

The data were then aggregated at weekly intervals. For each cluster and week, the total storm damage was computed by summing the mean monetary value assigned to each damage class. Specifically, each daily damage event was replaced by the average monetary damage associated with its class (as derived from the original dataset). Then, the total weekly damage was calculated as:
$ 
"Damage"_("week") = sum_("day" in "week") "MeanDamage"_("class"("day")) 
$ 
$"MeanDamage"_("class"("day"))$ is the average damage in CHF for the class of the damage event on that day. The averages were provided by K. Liechti (#abbr.a[WSL]):
- Class 1 (small): 0.06 Mio CHF
- Class 2 (medium): 0.8 Mio CHF
- Class 3 (large): 11.3 Mio CHF
 
The final dataset consists of entries with the following attributes per time window (week) and cluster center:
- `end_date`: last day of the week
- `center_municipality`: name of the cluster centroid
- `cluster_center_latitude`, `cluster_center_longitude`: Geographical coordinates of the cluster center
- `damage_grouped`: aggregated and binned damage label (0-3)
To convert the continuous aggregated damage values into categorical classes, we defined a binning procedure based on quantiles of the non-zero damage distribution.

Let $D = {d_1, d_2, dots, d_n}$ be the set of non-zero aggregated damae values and $q_1, q_2, q_3$ be the proportions of the damage classes where $q_1 = 0.9005, q_2 = 0.0667, q_3 = 0.0328$. The bin thresholds $T_("lowe")$ and $T_("mid")$ were computed as: 
$ 
  T_("low") = "percentile"(D, 100 * q_1) \ T_("mid") = "percentile"(D, 100 * (q_1 + q_2)) 
$ 
They also depend on the number of spatial clusters $k$, which determines how many data points contribute to the distribution of damages per region.  Then, the aggregated damage values were classified into four ordinal classes based on the following thresholds:
  - Class 0: $(d = 0)$
  - Class 1: $(0, T_("low")]$
  - Class 2: $(T_("low"), T_("mid")]$
  - Class 3: $(T_("mid"), infinity)$