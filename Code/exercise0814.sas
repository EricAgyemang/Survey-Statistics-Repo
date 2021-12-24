 /* Generates nonrespondents with probability proportional to acres87 and selects an SRS 
    with missing data. For use with Exercise 14 of Chapter 8 in Sampling: Design and Analysis, 2nd ed.
    Copyright 2009 Sharon Lohr */

filename agpop 'C:\agpop.csv';

options ls=78 nodate;

data agpop;
   infile agpop delimiter= ',' firstobs = 2;
   input county $ state $ acres92 acres87 acres82 farms92
                          farms87 farms82 largef92 largef87
                          largef82 smallf92 smallf87 smallf82 region $;

   if acres92 < 200000 then lt200k = 1;
      else if acres92 >= 200000 then lt200k = 0; /*  counties with fewer than 200000 acres in farms */
   if acres92 = -99 then acres92 =  . ;  /* check for missing values */
   if acres87 = -99 then acres87 = .;
   if acres92 = -99 then lt200k =  . ;
   sampwt = 3078/300;  /* sampling weight is same for each observation */
   phi = acres87/963466689;
run;

proc surveyselect data=agpop method=srs n=400 out = srsag seed = 325374 stats;
   /* if seed is not specified, SAS calculates a seed using the computer clock*/
   /* stats gives selection probs and sampling weights in the `out' dataset */

/* Now select respondents with probabilities proportional to acres87 */

data missdata;
   set srsag;
   retain seed 41028;
   call ranuni(seed,runif1);
   if runif1*16 ge log(acres87) then delete; 

proc print data=missdata (obs=20);
run;
