/* Selects a stratified random sample from a population, for Example 3.10 of Sampling: Design and Analysis,
   2nd ed., by Sharon L. Lohr.  Copyright 2009, Sharon L. Lohr */

/* Generate the sampling units for the population */

data caribou_count;
   input stratum $ count;
   datalines;
A 400
B  30
C  61
D  18
E  70
F 120
;
 
data caribou_pop;
   set caribou_count;
   do i = 1 to count;
      output ;
   end;

data caribou_pop;
   set caribou_pop;
   idnum = _n_;
run;

proc print data=caribou_pop;
run;
   
   /* Before selecting a sample, you need to sort the data file 
	  by the stratification variables. */

proc sort data=caribou_pop;
   by stratum;

   /* The following selects a stratified sample with 10 observations from each stratum */

proc surveyselect data=caribou_pop method=srs n=10 out = carib10 seed = 32348340 stats;
   strata stratum;
run;

proc print data=carib10;
run;

/* Check the sample size in each stratum */

proc freq data=carib10;
   tables stratum;  
run;

/* Select a sample of size 211 with proportional allocation */


proc surveyselect data=caribou_pop method=srs n=211 out = caribprop seed = 10642750 stats;
   strata stratum / alloc = prop;
run;

proc print data=caribprop;
run;

/* Check the sample size in each stratum */

proc freq data=caribprop;
   tables stratum;  
run;

/* We used proportional allocation above.
   Other options are "alloc = optimal" and "alloc = Neyman". For these, you need
   to provide a data set with the variances. For optimal allocation, you need to
   also provide a data set with the costs for each stratum. 
   Let's use Neyman allocation here. The data set must have the variances in
   the variable _var_ . */

data neyvar;
  input stratum $ stdev;
  _var_ = stdev*stdev;
  datalines;
A 3000
B 2000
C 9000
D 2000
E 12000
F 1000
;
 
proc surveyselect data=caribou_pop method=srs n=225 out = carib_neyman seed = 1836565293 stats;
   strata stratum / alloc = neyman var = neyvar;
run;

proc print data=carib_neyman;
run;

/* Check the sample size in each stratum */

proc freq data=carib_neyman;
   tables stratum;  
run;
