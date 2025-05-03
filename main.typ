#import "@preview/scholarly-epfl-thesis:0.2.0": template, front-matter, main-matter, back-matter

#show: template.with(author: "Nils Gämperli, Damian Ueltschi")

// #set pagebreak(weak: true)
#set page(numbering: none)

#include "head/cover-page.typ"
#pagebreak()
#show: front-matter
#include "head/declaration_of_authorship.typ"
#pagebreak()
#pagebreak()
#include "head/dedication.typ"

#show: front-matter
#include "head/abstract.typ"
#include "head/acknowledgments.typ"
#include "head/preface.typ"

#show: front-matter
#outline(title: "Contents")


#show: main-matter

#include "main/ch1_introduction.typ"
#include "main/ch2_theoretical_background.typ"
#include "main/ch3_methodology.typ"
#include "main/ch4_results.typ"
#include "main/ch5_discussion_outlook.typ"
  
#show: back-matter
#include "tail/biblio.typ"
#outline(title: "List of Figures", target: figure.where(kind: image))
#outline(title: "List of Tables", target: figure.where(kind: table))

#include "tail/appendix.typ"

// #include "tail/cv/cv"
