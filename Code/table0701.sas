/* This SAS program produces the values in Table 7.1 of Sampling: Design and Analysis, 2nd ed.
   Copyright 2009 Sharon L. Lohr*/

filename htpop "C:\htpop.csv";
filename htsrs "C:\htsrs.csv";
filename htstrat "C:\htstrat.csv";

data htpop;
   infile htpop firstobs=2 delimiter=",";
   input height gender $;
   ht2 = height*height;
run;

data htsrs;
   infile htsrs firstobs=2 delimiter=",";
   input rn height gender $;
   wt =  10;
   ht2 = height*height;
run;

data htstrat;
   infile htstrat firstobs=2 delimiter=",";
   input rn height gender $; 
   ht2 = height*height;
   if gender = "F" then wt = 6.25;
   if gender = "M" then wt = 25;
run;

/* Gives the population values of the mean and variance.  */
proc univariate data=htpop;
   var height;
run;

/* Gives the population values of the quantiles. We use proc surveymeans
   rather than proc univariate since proc univariate does not give
   the interpolated values. */
proc surveymeans data=htpop mean percentile=(25 50 90); /* gives interpolated values */
   var height ht2;
run;

proc surveymeans data=htsrs mean sum percentile=(25 50 90);
   var height ht2;
   weight wt;
   ods output Statistics = SRSstat; 
run;

proc print data=SRSstat;
run;

/* We use the statistics in SRSstat to calculate the variance using (7.3),
   taking (1/1999)(sum of ht2 - (sum of height)^2/2000) */

/* Or we can estimate the variance using proc univariate */
proc univariate data=htsrs;
   var height;
run;

proc surveymeans data=htstrat mean sum percentile=(25 50 90); /* no weights*/
   var height ht2;
run;

proc univariate data=htstrat;
   var height;
run;

proc surveymeans data=htstrat mean sum percentile=(25 50 90);
   var height ht2;
   weight wt;
run;

