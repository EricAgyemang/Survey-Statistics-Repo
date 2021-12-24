/* Selects a pps sample from an artificial population.
   We create the population in the data step with random values of M_i,
   then select different samples. 
   For use with Sampling: Design and Analysis, 2nd ed. by Sharon L. Lohr
   Copyright 2008 by Sharon L. Lohr */

data popn; /* create population */
   seed = 237573;
   do PsuID = 1 to 200;
      call ranpoi(seed, 30, size); 
	  size = size + 2;  /* Make sure every psu has at least 2 ssu's */
	  do SsuID = 1 to size;
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

proc surveyselect data=PsuIDList method=pps n=10 out = PsuSample seed = 32580 stats;
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

/* Now take an SRS of the same number of ssu's (here, 2) from each psu. */

proc surveyselect data=Onestage method=srs n=2 out = SsuSample seed = 34358 stats selectall;
    strata PsuID;
run;
proc print data = SsuSample;
run;

/* Note that the SamplingWeight from the 2nd stage of selection only includes the
   M_i/m_i part.  We need to multiply this weight times the psu sampling weight
   from before to get the full weight. */

data SsuSample;
   set SsuSample;
   myweight = SamplingWeight * Psuweight;

proc print data = SsuSample;
run;

