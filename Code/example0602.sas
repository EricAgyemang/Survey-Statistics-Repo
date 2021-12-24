 /* This sas program will select a pps sample as in Example 6.2
    of Sampling:  Design and Analysis, 2nd ed. by Sharon L. Lohr,
    using Version 9 of SAS. (The sample will differ from the
    one chosen in the book; in fact, you will get a different
    sample every time you run this program.)  
    Copyright 2008 Sharon L. Lohr*/

options ls=78 nodate nocenter;
 
data classes;
   input class clssize ;
   datalines;
1 44
2 33
3 26
4 22
5 76
6 63
7 20
8 44
9 54
10 34
11 46
12 24
13 46
14 100
15 15
;

proc print data=classes;
run;

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

data mysample;
   set mysample;
   do i = 1 to NumberHits;
      output;
   end;
run;

proc print data=mysample;
run;

 /* Let's select another with-replacement sample, with a different seed. */

proc surveyselect data=classes out=mysamp2 sampsize=5 method=pps_wr seed=170682;
   size clssize;
   id class;

proc print data=mysamp2;
run;

data mysamp2;
   set mysamp2;
   do i = 1 to NumberHits;
      output;
   end;
run;

proc print data=mysamp2;
run;


 /* Select a systematic sample of psu's with prob proportional to clssize */

proc surveyselect data=classes out=mysamp3 sampsize=5 method=pps_sys seed=129402;
   size clssize;
   id class;

proc print data=mysamp3;
run;

 /* Select a sample of size 2 with pps and without replacement, using
    Brewer's method */
proc surveyselect data=classes out=worpl sampsize=2 method=pps_brewer jtprobs;
   /* option jtprobs gives the \pi_{ij}, joint probs of selection, needed for exact variance est */
   size clssize;
   id class;
proc print data=worpl;
run;

 /* Select a sample of size 5 with pps and without replacement, using
    the Hanurav-Vijayan method */
proc surveyselect data=classes out=worpl sampsize=5 method=pps jtprobs;
   size clssize;
   id class;
proc print data=worpl;
run;

