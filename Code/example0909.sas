/* Analyzes the data in Example 9.9 of Sampling: Design and Analysis, 2nd ed.
   using bootstrap.
   Copyright 2009 Sharon L. Lohr */

options ls=78 nocenter nodate;
filename htsrs 'C:\htsrs.csv';


data htsrs;
   infile htsrs delimiter= ',' firstobs = 2;
   input rn height gender $;
   wt = 2000/200;
   stratvar=1;
   psuvar=_N_;
run;

/* PROC SURVEYMEANS will calculate Woodruff-based CIs for quantiles from survey data */
   
/* Here is code for estimating the median and other quantiles along with a with-replacement
   standard error. Note that SAS PROC SURVEYMEANS defines the quantiles slightly differently
   than in the textbook. This leads to a different estimate of the variance than
   SAS gives in PROC MEANS or PROC UNIVARIATE. */

proc freq data=htsrs;
    tables height;
run;

proc univariate data=htsrs;
    var height;

proc means data=htsrs mean median p25 p90 var;
    var height;
run;
proc surveymeans data=htsrs mean total=2000 percentile=(0 25 50 75 100) nonsymcl;
  /* option nonsymcl gives the CI in Section 9.5.2. If you omit option nonsymcl,
     SAS calculates a SE from the CI and forms a symmetric CI using the SE. */
	weight wt;
    var height;
run;

/* For comparison with the bootstrap method in Example 9.9, here is the
   analysis ignoring the fpc */

proc surveymeans data=htsrs mean percentile=(0 25 50 75 100);
	weight wt;
    var height;
run;

/* We use the macros bootwt and bootmed from example0910.sas */
%bootwt(htsrs,wt,stratvar,psuvar,500);

%bootmed(fullrep,height,wt,repwt,500);

proc print data=varmed;
run;



