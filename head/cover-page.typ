#page(
  numbering: none, margin: (y: 6cm), {
    set text(font: "Helvetica")

    align(
      center, [
        #let v-skip = v(1em, weak: true)
        #let v-space = v(2em, weak: true)

        #text(size: 25pt)[
          StormMind \
          Deep Learning based Web-Service\ for Storm Damage Forecasting \
          
          Bachelor Thesis\
        ]

        #v-space

        #text(fill: gray)[
        ZHAW School of Engineering\
        Institute of Computer Science 
        ]

        #v-space

        #v(1fr)

        #grid(
          columns: (1fr, 60%), align(horizon, image("images/zhaw_rgb.jpg", width: 75%)), align(left)[
          
            Submitted on: 
            #h(2.01cm) 06.06.2025\
            #v-space
            Authors:
            #h(2.94cm) Gämperli Nils\
            #h(4.49cm) Ueltschi Damian
            #v-space
            Supervisor:
            #h(2.445cm)Andreas Meier
            #v-space
            Study Program:
            #h(1.7cm) Computer Science
            
          ],
        )
      ],
    )
  },
)
