/* This SAS code calculates the results from Example 4.9 in
   Sampling: Design and Analysis, 2nd ed. by S. Lohr
   Copyright 2008 by S. Lohr*/
options nocenter ls=78;
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
;

proc gplot data=trees;
   plot field*photo;

   /* Calculate summary statistics to substitute in formulae for variance*/
proc univariate data=trees;
   var field;
proc corr data=trees;
   var field photo;
run;

proc surveymeans data=trees total=100;
   var field;
   weight treewt;
run;

   /* Use proc surveyreg to estimate the total number of trees */
proc surveyreg data=trees total=100;
   model field=photo / clparm solution ; /* fits the regression model */
   weight treewt;
   estimate 'Total field trees' intercept 100 photo 1130;
          /* substitute N for intercept, t_x for photo */
   estimate 'Mean field trees' intercept 100 photo 1130/divisor=100;
run;


