/* Selects an stratified random sample from a population, for Chapter 3 of Sampling: Design and Analysis,
   2nd ed., by Sharon L. Lohr.  Copyright 2009, Sharon L. Lohr */

/* We illustrate proc surveyselect by selecting a stratified random sample from the 
   population in agpop.csv.  Note that the stratum sample sizes you will use in Exercise 13 of
   Chapter 3 will differ from the sample sizes we use here. */

filename agpop 'C:\agpop.csv';
options ls=78 nodate;

data agpop;
   infile agpop delimiter= ',' firstobs = 2;
   input county $ state $ acres92 acres87 acres82 farms92
                          farms87 farms82 largef92 largef87
                          largef82 smallf92 smallf87 smallf82 region $;

   /* Select a sample with n = 400 and proportional allocation
	  Before selecting the sample, you need to sort the data file 
	  by the stratification variables. */

proc sort data=agpop;
   by region;

proc surveyselect data=agpop method=srs n=400 out = propag seed = 32348340 stats;
   strata region / alloc = prop;
run;

proc print data=propag (obs=20);
   var region county state acres92 SelectionProb SamplingWeight;
run;

/* Check the sample size in each stratum */

proc freq data=propag;
   tables region;  
run;

/* We used proportional allocation above.
   Other options are "alloc = optimal" and "alloc = Neyman". For these, you need
   to provide a data set with the variances. For optimal allocation, you need to
   also provide a data set with the costs for each stratum. */

 /* Select a stratified random sample with specified sample sizes.
    In "alloc = (values)", specify the proportion of the sample that comes 
    from each stratum.  The values must be in the same order as the sorted data set. 
    You can also specify a SAS data set that has the desired proportions. */

proc surveyselect data=agpop method=srs n=400 out = ag2 seed = 584357 stats;
   strata region / alloc = (0.2 0.3 0.4 0.1);
run;

proc print data=ag2;
   var region county state acres92 SelectionProb SamplingWeight;
run;

/* Check the sample size in each stratum */

proc freq data=ag2;
   tables region;  
run;

/* Alternatively, give a list or data set in the sampsize option. 
   Since we use the same seed, this gives the same sample as in ag2 above. */

proc surveyselect data=agpop method=srs sampsize = (80 120 160 40) out = ag3 seed = 584357 stats;
   strata region;
run;

proc print data=ag3;
   var region county state acres92 SelectionProb SamplingWeight;
run;

/* Check the sample size in each stratum */

proc freq data=ag2;
   tables region;  
run;
