/* Analyzes the data in Examples 3.2 and 3.6 of Sampling: Design and Analysis, 2nd ed. by S. Lohr 
   Copyright 2009 by Sharon Lohr */

filename agstrat 'C:\agstrat.csv';

options ls=90  nodate; 
data agstrat;
   infile agstrat delimiter= ',' firstobs = 2;
   input county $ state $ acres92 acres87 acres82 farms92
                          farms87 farms82 largef92 largef87
                          largef82 smallf92 smallf87 smallf82 
                          region $ rn strwt;
   if acres92 < 200000 then lt200k = 1;
      else if acres92 >= 200000 then lt200k = 0; /*  counties with fewer than 200000 acres in farms */
   if acres92 = -99 then acres92 =  . ;  /* check for missing values */
   if acres92 = -99 then lt200k =  . ;  

proc sort data=agstrat;
  by region;

proc univariate data=agstrat plot;
  /* creates crummy looking line printer boxplots */
   var acres92;
   by region;
run;

proc boxplot data = agstrat;
  /* creates pretty boxplots if you have SAS for Windows */
   plot acres92 * region;
run;

/* Create dataset containing strata totals. If you have small sampling fractions,
   you need this extra dataset to be able to use the fpc. */

data strattot;
   input region $  _total_;
   cards;
NE 220
NC 1054
S  1382
W  422
;
proc print data=strattot;

/* Important:  You need BOTH the weight statement AND the stratum statement! 
   If you omit the weight statement, SAS assigns weight 1 to every observation;
   if you have disproportionate allocation, estimates of the mean will be biased.
   If you omit the stratum statement, the variances will be wrong. 
   Try it without one of these statements and see what happens. */

/* The following gives the output printed in Example 3.6 */

proc surveymeans data=agstrat total = strattot nobs mean sum clm clsum df; 
   stratum region ;
   var acres92 ;
   weight strwt;
run;

/* We can also add more variables and list the details of the stratification. */

proc surveymeans data=agstrat total = strattot nobs mean sum clm clsum df; 
   class lt200k;
   stratum region /list;
   var acres92 lt200k;
   weight strwt;
   ods output Statistics=myout;

proc print data=myout;
run;


