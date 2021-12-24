 /* Takes a two-phase sample from agpop.dat, and uses linearization to estimate the variance.
    Gives the output in Example 12.6 of Sampling: Design and Analysis, 2nd ed. by Sharon L. Lohr
    Copyright 2009 Sharon Lohr */

filename agpop 'C:\agpop.csv';
options ls=78 nodate;

data agpop;
   infile agpop delimiter= ',' firstobs = 2;
   input county $ state $ acres92 acres87 acres82 farms92
                          farms87 farms82 largef92 largef87
                          largef82 smallf92 smallf87 smallf82;
   if acres92 = -99 then acres92=.;
   if acres87 = -99 then acres87=1;   
      /* To illustrate the method, I'm imputing 1 for
         the missing values of x */
   obsnum = _N_;
run;

   /* Select the phase I sample */

proc surveyselect data=agpop method=srs n=400 out = srsag1 seed = 20513518 stats;
run;

   /* Rename the sampling weight for the phase I sample so it is not
      overwritten when we select the phase II sample */

data srsag1 (drop = seed SamplingWeight SelectionProb);
   set srsag1;
   phase1wt = SamplingWeight;
run;

   /* Now select the phase II sample. */

proc surveyselect data=srsag1 method=srs n=30 out = srsag2 seed =48375 stats;
run;

/* Calculate the weights for the phase II sample */

data srsag2;
    set srsag2;
	phase2wt = SamplingWeight;
	wtprod = phase1wt*phase2wt;
run;

proc print data=srsag2;
   var obsnum acres92;
run;

/* Calculate the estimated population total t_x (x=acres87) for the phase I sample */

proc surveymeans data=srsag1 sum mean ;
    weight phase1wt;
	var acres87;
	ods output Statistics=phase1stat;
run;

proc print data=phase1stat;
run;

/* Calculate the phase II ratio, \hat{B} */

proc surveymeans data=srsag2 ;
    weight wtprod;
	var acres92 acres87;
	ratio acres92/acres87;
	ods output Statistics = phase2stat;
	ods output Ratio = phase2ratio;
run;

/* Calculate the linearization variance of the two-phase ratio estimator,
   using the quantities output by proc surveymeans.
   We note that \hat{V}(\hat{B}) = s^2_e / (n \bar{x}^2) */

proc means data=srsag2 mean var; var acres92 acres87; run;
proc print data=phase2ratio;
proc print data=phase2stat;
run;





