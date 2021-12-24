/* Analyzes the small data set in Table 9.2 of Sampling: Design and Analysis, 2nd ed.
   using balanced repeated replication
   Copyright 2009 Sharon L. Lohr */

data brrex;
   input strat strfrac y;
   datalines;
1 .3 2000
1 .3 1792
2 .1 4525
2 .1 4735
3 .05 9550
3 .05 14060
4 .1 800
4 .1 1250
5 .2 9300
5 .2 7264
6 .05 13286
6 .05 12840
7 .2 2106
7 .2 2070
;

/* Calculate the variance of ybar using the stratified sampling formula */

proc surveymeans data=brrex mean clm percentile=(25 50 75 ) ;
  stratum strat;
  weight strfrac; 
     /* strfrac is the relative weight for each obsn, proportional to N_h/n_h */
  var y ;
run;

/* Construct the Hadamard matrix for a BRR analysis of the data.
   We tell SAS to use BRR by including varmethod=brr as an option.
   For this example, we tell SAS to save the replicate weights in
   data set "repwts" and to print the Hadamard matrix (option printh). */

proc surveymeans data=brrex mean clm varmethod=brr(outweights=repwts printh);
  stratum strat;
  weight strfrac;
  var y ;
run;

proc print data=repwts;
run;

