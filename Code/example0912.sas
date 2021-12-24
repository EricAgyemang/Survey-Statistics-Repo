/* Does calculations in Example 9.12 of
   Sampling: Design and Analysis, 2nd ed.
   by Sharon L. Lohr. Copyright 2009 Sharon Lohr */

options ls=78 nocenter nodate;
filename htstrat 'C:\htstrat.csv';

data htstrat;
   infile htstrat delimiter= ',' firstobs = 2;
   input rn height gender $;
   if gender = "F" then wt = 6.25;
   else if gender = "M" then wt = 25;
run;


/* PROC SURVEYMEANS will calculate Woodruff-based CIs for quantiles from survey data */
   
/* Here is code for estimating the median and other quantiles along with a with-replacement
   standard error. Note that SAS PROC SURVEYMEANS defines the quantiles slightly differently
   than in the textbook. This leads to a different estimate of the variance than
   SAS gives in PROC MEANS or PROC UNIVARIATE. */

proc surveymeans data=htstrat mean percentile=(0 25 50 75 100);
	weight wt;
	stratum gender;	
    var height;
run;


