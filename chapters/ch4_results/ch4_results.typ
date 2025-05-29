#import "@preview/abbr:0.2.3"
= Results


== Results of AI Engineering
To evaluate model performance, we conducted x experiments based on the configurations detailed in @experiemnt-set-up. The first experiment, using a standard feedforward network, serves as the baseline. The setup was described in @fnn_setup

---------

INSERT COMPARISON OF ALL MODELS TABLE

-------

#include "sub1_fnn.typ"
#include "sub2_lstm_nn.typ"
#include "sub3_transformer.typ"

== Combined
== Conclusion

#figure(
table(
  columns: 5,
  [*Model*], [Accuracy], [Precision], [F1], [AUC],

  [FNN], [], [], [], [],
  [LSTM], [0.703], [0.672], [0.676], [0.747],
  [Transformer], [], [], [],[]
),
caption: [Results of the different experiments on the hold out test set]
)<moel-comparision>

== Software Results


