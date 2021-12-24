 /* This sas program will produce the estimates in Example 6.4
    of Sampling:  Design and Analysis 2nd ed. by Sharon L. Lohr,
    Copyright (c) Sharon L. Lohr, 2008 */

options ls=78 nodate nocenter;
 
data studystat;
   input class Mi tothours;
   classwt = 647/(Mi*5);
   datalines;
12 24 75
14 100 203
14 100 203
5 76 191
1 44 168
;

 /* Note that it's important how you enter weights here; we want to sum w_i t_i as in (6.5),
    so we use a weight of 1/(n \psi_i) =  (sum of Mi)/(n M_i).
    Also, class 14 is sampled twice, so we include it twice in the data set. */

proc print data=studystat;

 /* We omit the 'total' option in the first line because sampling is with replacement. */
 /* We can estimate \bar{y}_U  by using the ratio. Because we have an exact pps design,
    the denominator (sum of the weights) is 647 for every possible sample. */

proc surveymeans data=studystat nobs mean sum clm clsum;
   var tothours;
   weight classwt;
   ratio tothours/Mi;
run;

/* Let's look at the data set in mysample, created in example0602.sas.  If we use the values
   from that sample, we need to create the dataset with multiple records for the classes that
   are selected more than once in order to analyze the sample. */

data classes;
   input class clssize ti;
   datalines;
1 44 168
2 33 150
3 26 .
4 22 .
5 76 .
6 63 .
7 20 .
8 44 .
9 54 .
10 34 .
11 46 .
12 24 .
13 46 .
14 100 304
15 15 47 
;

 /* Select a sample of size 5 with prob proportional to size and
    with replacement.  The units to be selected will be put in
    file 'mysample'. */

proc surveyselect data=classes out=mysample sampsize=5 method=pps_wr seed=4082;
   size clssize; /* select psu's with prob proportional to clssize */ 
   id class;

proc print data=mysample;
run;

/* The "Expected Hits" column in SAS is (n)(\psi_i) = n (selection probability).
   For class 1, Expected Hits = (5)(.068006) = 0.34003.
   For class 14, Expected Hits = (5)(.15456) = 0.7728.
   The "Sampling Weight" is 1/(Expected Hits) for with-replacement sampling.*/

/* Note that the output file in mysample selects class 14 twice; this is indicated
   by "Number Hits" = 2.  If selecting the sample and analyzing the data as an
   unequal-probability sample with replacement, you need to include each unit
   as many times as it is selected to be in the sample. The following will give
   you the list of units you need to include. */

proc sort data=mysample;
   by class;
proc sort data=classes;
   by class;

data mysample; /* Get the value of ti for the sampled classes and create 5 records */
   merge mysample classes;
   by class;
   if ti ne .;
   do i = 1 to NumberHits;
      output;
   end;
run;

proc print data=mysample;
run;

proc surveymeans data=mysample sum clsum;
   weight SamplingWeight;
   var ti;
run;
