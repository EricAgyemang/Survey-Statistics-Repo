/* For use with
   Sampling: Design and Analysis, 2nd ed., by Sharon L. Lohr. Copyright 2009, Sharon L. Lohr   */

/* Selects a two-stage cluster sample from an artificial population.
   We create the population in the data step with random values of M_i,
   then select different samples. */

/* We first create an artificial population.  If taking a sample from a real
   population, of course, you do not need to do this step. */

data popn; 
   seed = 23573;
   retain clustereffect 3;
   do PsuID = 1 to 200;
      call ranpoi(seed, 30, size); 
	  clustereffect = rannor(seed); /* Generate a cluster effect */
	  size = size + 2;  /* Make sure every psu has at least 2 ssu's */
	  do SsuID = 1 to size;
	      y = clustereffect + 1.3*rannor(seed);  
		    /* Generate the observation y. */
          output;
	  end;
   end;

proc means data=popn;
proc print data=popn;
run;

/* Create data set of individual psu's */

proc freq data=popn noprint;
    tables PsuID / out=PsuIDList(drop=count percent);
run;

proc print data = PsuIDList;
run;

/* Take pps sample of 10 psu's */

proc surveyselect data=PsuIDList method=srs n=10 out = PsuSample seed = 85726 stats;
run;
proc print data = PsuSample;
run;
  
/* Now merge with original data set. This gives a one-stage cluster sample. */

data Onestage (drop=seed SamplingWeight SelectionProb);
   merge PsuSample(in=Insample) popn(in=Inpop);
    /* When a data set contributes an observation for the current BY group, 
       the IN= value is 1. */
   by PsuID;
   if Insample and Inpop; /*delete obsns not in both PsuSample and popn */
   Psuweight = SamplingWeight; 	/* rename SamplingWeight for later use */
   Psuselectprob = SelectionProb;   /* rename SelectionProb for later use */
run;

proc print data = Onestage;
run;

/* If you want a one-stage cluster sample, stop here. */

/* Now take an SRS with the same sampling fraction (here 10%) in each psu. Ensure that
   a minimum of 2 ssus is taken in each psu with the nmin option. */

proc surveyselect data=Onestage method=srs samprate=10 out = SsuSample seed = 34358 stats nmin=2;
    strata PsuID;
run;
proc print data = SsuSample;
run;

/* Note that the SamplingWeight from the 2nd stage of selection only includes the
   M_i/m_i part.  We need to multiply this weight times the psu sampling weight
   from before to get the full weight. */

data SsuSample;
   set SsuSample;
   finalweight = SamplingWeight * Psuweight;

proc print data = SsuSample;
run;

 /* SsuSample contains the two-stage cluster sample */

 /* Finally, let's analyze the data using PROC SURVEYMEANS */

proc surveymeans data=SSuSample total=200;
    weight finalweight;
    cluster PsuID;
    var y;
run;
