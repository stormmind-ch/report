#import "abbr-impl.typ"
#import "abbr.typ"
#import "template.typ"
#abbr.load("abbreviations.csv", delimiter:",")

#show: template.template.with(author: "Nils Gämperli, Damian Ueltschi")

#set pagebreak(weak: true)
#set page(numbering: none)

#include "head/cover-page.typ"
#pagebreak()
#show: template.front-matter        
#include "head/declaration_of_authorship.typ"
#pagebreak()
#include "head/dedication.typ"
#include "head/abstract.typ"
#include "head/acknowledgments.typ"
#include "head/preface.typ"


#outline(title: "Table of Contents")




#show: template.main-matter

#include "chapters/ch1_introduction/ch1_introduction.typ"
#include "chapters/ch2theoretical_background/ch2_theoretical_background.typ"
#include "chapters/ch3_methodology/ch3_methodology.typ"
#include "chapters/ch4_results/ch4_results.typ"
#include "chapters/ch5_discussion_outlook/ch5_discussion_outlook.typ"




#show: template.back-matter
#abbr.list()
#include "tail/biblio.typ"
#outline(title: "List of Figures", target: figure.where(kind: image))
#outline(title: "List of Tables", target: figure.where(kind: table))

#include "tail/appendix.typ"

// #include "tail/cv/cv"
