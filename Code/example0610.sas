 /* This sas program will select a pps sample without replacement
    given in Example 6.10 of Sampling:  Design and Analysis, 2nd ed. by Sharon L. Lohr,
    using Version 9 of SAS.   
    Copyright 2008 Sharon L. Lohr*/

filename agpop 'C:\agpop.csv';
filename agpps 'C:\agpps.csv';

options ls=78 nodate nocenter;
 
data agpop;
   infile agpop delimiter= ',' firstobs = 2;
   input county $ state $ acres92 acres87 acres82 farms92
                          farms87 farms82 largef92 largef87
                          largef82 smallf92 smallf87 smallf82;

   if acres87 >= 0 then sizemeas = acres87; /* some acres87's are missing */
      else if acres82 >=0 then sizemeas = acres82;
	  else sizemeas = 206327; /* if all missing, impute median of acres87 */

proc surveyselect data=agpop method=pps jtprobs n=15 out = agpps seed = 783874 stats;
 /* option jtprobs specifies that joint inclusion probs should be output*/
   size sizemeas;

data agpps (drop=farms92 farms87 farms82 largef92 largef87 largef82 acres82
            smallf92 smallf87 smallf82);
   set agpps;
   file agpps delimiter=",";
   put county state acres92 acres87 sizemeas SelectionProb SamplingWeight JtProb_1-JtProb_15;

proc print data = agpps;
run;

proc surveymeans data=agpps nobs mean sum clm clsum;
   /* calculates with-replacement variance since total option missing*/
   var acres92;
   weight SamplingWeight;
run;



