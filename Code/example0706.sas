 /* This sas program provides the output in
    in Example 7.6 of Sampling:  Design and Analysis, 2nd ed. by Sharon L. Lohr,
    using Version 9.2 of SAS.  Copyright 2008 Sharon L. Lohr*/

options ls=78 nocenter nodate;
filename htstrat 'C:\htstrat.csv';

data htstrat;
   infile htstrat delimiter= ',' firstobs = 2;
   input rn height gender $;
   if gender = "F" then wt = 6.25;
   else if gender = "M" then wt = 25;
run;
   
proc surveymeans data=htstrat mean total=1000 percentile=(0 25 50 75 100) nonsymcl;
	weight wt;
	stratum gender;	
    var height;
run;

/* As of this writing, SAS PROC SURVEYMEANS does not calculate quantiles
   for domains.  One can force it to provide point estimates by using
   a subset of the data that only contains observations in the domain of
   interest, but the standard errors may be wrong in some data sets. 
   In these data, the domains are strata, so the standard errors are ok here. */

proc surveymeans data=htstrat mean percentile=(0 25 50 75 100) nonsymcl;
	by gender;	
	/* Warning:  The BY statement creates subsets of the data corresponding
	to each BY group. In general, if you use only a subset of the data
    in proc surveymeans instead of using the domain statement,
    your standard errors may be wrong. */
    weight wt;
	var height;
run;

/* proc boxplot does not use weights in constructing a boxplot.
   However, proc anom in SAS/QC can use summary statistics to construct
   a skeletal boxplot.  We create the summary statistics from proc
   surveymeans using the weights, then import them to proc anom */

data htquants;
   input group $ qL q1 qX qM q3 qH qS qN;
   /* q is the variable name; the suffix refers to the quantiles,
      L = min, 1=1st quartile, X=mean, M=median, 3=3rd quartile,
      H = max (high), S = std deviation, N=sample size */
   /* We used standard error of the mean for S, which is not correct,
      but we're not using it in the plot anyway */
    datalines;
All    142 160.714 169.01562 167.555 176.625 200 .74 200
Female 142 155.666 161.73    160.714 166.400 180 .59 160
Male   163 169 176.3 176 180 200 1.35 40
;

proc anom summary=htquants;
       boxchart q*group / nolimits;
run;

