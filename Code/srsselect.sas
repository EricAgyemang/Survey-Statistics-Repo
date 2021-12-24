/* Selects an SRS from a population, described on page 32 of Sampling: Design and Analysis,
   2nd ed., by Sharon L. Lohr.  Copyright 2009, Sharon L. Lohr */

/* We illustrate proc surveyselect by selecting an SRS from the population in agpop.csv,
   used in Example 2.5.  The sample selected by SAS will be different from the one
   in Example 2.5 */

filename agpop 'C:\agpop.csv';
options ls=78 nodate;

data agpop;
   infile agpop delimiter= ',' firstobs = 2;
   input county $ state $ acres92 acres87 acres82 farms92
                          farms87 farms82 largef92 largef87
                          largef82 smallf92 smallf87 smallf82 region $;

proc surveyselect data=agpop method=srs n=100 out = srsag seed = 32580 stats;
   /* Selects an SRS of size 100 and puts the sample in file srsag. */
   /* If seed is not specified, SAS calculates a seed using the computer clock;
      I recommend using seed so you can re-create the sample if necessary. */
   /* stats gives selection probs and sampling weights in the `out' dataset */

proc print data=srsag (obs=20);
   var county state acres92 SelectionProb SamplingWeight;

  /* other options for selecting an SRS */

proc surveyselect data=agpop method=srs samprate=2 out = srsag1 seed = 32580 stats;
  /* By specifying samprate rather than n=100, select 2% of the units for the sample.
     Samprate specifies the sampling fraction. */

proc print data=srsag1 (obs=10);
run;
