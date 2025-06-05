#import "../abbr-impl.typ"
#import "../abbr.typ"

#set heading(numbering: "A.1.1", supplement: [Appendix])

= Appendix

//== Informationen zu den Daten aus der Unwetterschadens-Datenbank WSL

//Bitte beachten Sie folgendes bei der Benutzung der Daten:

//- Die Gemeindenamen werden auf dem Stand 1996 aufgenommen. D.h. einige Gemeinden haben mittlerweile fusioniert.
//- Als Informationsquelle dienen hauptsächlich Medienberichte. Es gibt lokale und regionale Unterschiede in der Berichterstattung. Ausserdem hat sich der Fokus der Medien im Laufe der Zeit verändert.
//- Teilweise ist die Orts- und / oder Gemeinde-Zuweisung eines Schadens schwierig (in wenigen Zweifelsfällen werden die Schäden dem jeweiligen Kantonshauptort oder gar der Schweizer Hauptstadt zugeordnet).
//- Die Koordinaten sind aufgrund von Informationen aus den Medienberichten, Abbildungen o.ä. gesetzt worden. Sie können somit stark vom wirklichen Schadenshauptpunkt abweichen.

//Bei einer Publikation muss folgendes beachtet werden:

//- Werden  die  Datenwerte  zitiert  oder  veröffentlicht,  sind  sie  mindestens  mit  einer Quellenangabe („WSL Unwetterschadens-Datenbank der Schweiz“  oder „Swiss flood and landslide damage database“) zu versehen.
//- Es muss deutlich erwähnt werden, dass es sich nur um Schätzungen handelt.
//- Schadenszahlen müssen in Publikationen immer gerundet werden.
//- Es dürfen keine Schadensdaten auf Gemeindeebene, sondern nur in aggregierter Form (Regionen, Kantone) veröffentlicht werden.
//- Schadensdaten dürfen nur in einer Form veröffentlicht werden, die keine Rückschlüsse auf einzelne Objekte oder Personen zulässt. 

== Disclaimer<disclaimer>
 
 
"
*Information on the Data of the Swiss flood and landslide damage database managed by WSL*

Please note the following when using the data:
 
- Names of municipalities refer to the state of 1996. I.e. some municipalities have merged.
- Media reports are the main source of information. There are local and regional differences in reporting. In addition, the focus of the media has changed over time.
- In some cases, it is difficult to assign the damage to a location and / or municipality (in a few cases of doubt, the damage is assigned to the respective canton capital or even the Swiss capital)
- The coordinates have been set based on information from media reports, images, etc. They can therefore deviate greatly from the real main point of damage.
 
The following must be observed when publishing:
 
- If  the  data  values  are  cited  or  published,  they  must  be  provided  with  at  least  a reference to the source ("WSL Swiss Flood and Landslide Damage Database").
- It must be clearly mentioned that the damage data are only estimates.
- Damage values must always be rounded in publications.
- No  monetary  damage  may  be  published  at  community  level,  but  only  in  aggregated form (regions, cantons).
- Monetary damage may only be published in a form that does not allow any conclusions to be drawn about individuals and individual objects."#cite(<swissfederalresearchinstitutewslInfos_Daten_Unwetterschadensdatenbank_WSL_english2023>)
#pagebreak()
== Original Data Features<weather-features>
Gemeinde,	Gemeindenummer,	Weitere Gemeinde,	Kanton,	Prozessraum,	MAXO Datum,	Datum,	MAXO Zeit,	Zeit,	Gewässer,	Weitere Gewässer,	Hauptprozess,	Hauptprozess Rutschung Unterteilung, Hauptprozess Wasser/Murgang Unterteilung, Weitere Prozesse,	Schadensausmass: gering [0.01-0.4]; mittel [0.4-2]; gross/katastrophal[>2] oder Todesfall [Mio. CHF],	x-Koordinate,	y-Koordinate,	Schadenszentrum; Gemeindegebiet falls nicht bekannt,	Grossereignisnummer; mehrere Ereignisse; welche aufgrund meteorologischer oder räumlicher Gegebenheiten zusammengefasst werden,	Gewitterdauer MAXO,	Gewitterdauer [Std.],	Gewitter Niederschlagsmenge MAXO,	Gewitter Niederschlagsmenge [mm],	Dauerregen Dauer MAXO,	Dauerregen Dauer [Std.],	Dauerregen Niederschlagsmenge MAXO,Dauerregen Niederschlagsmenge [mm], Schneeschmelze MAXO, Schneeschmelze, Ursache nicht bestimmbar MAXO, Ursache nicht bestimmbar, ID




