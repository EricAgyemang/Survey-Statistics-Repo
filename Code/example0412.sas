/* This SAS code calculates the results from Example 4.12 in
   Sampling: Design and Analysis, 2nd ed. by S. Lohr
   Copyright 2008 by S. Lohr*/

options nocenter ls=110;


/* Model-based analysis used in Example 4.12. We add an extra line to the data set
   with x = \bar{x}_U = 11.3 and y missing so that SAS will calculate the predicted
   value at \bar{x}_U. */

data trees;
   input photo field;
   poptotal = 100;
   treewt = 4;
   datalines;
 10    15
 12    14
  7     9
 13    14
 13     8
  6     5
 17    18
 16    15
 15    13
 10    15
 14    11
 12    15
 10    12
  5     8
 12    13
 10     9
 10    11
  9    12
  6     9
 11    12
  7    13
  9    11
 11    10
 10     9
 10     8 
 11.3   .
;

proc reg data=trees;
   model field=photo/ r p;
   output out=resids resid=resid pred = pred;
run;

