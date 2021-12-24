 /* This sas program selects and analyzes the without-replacement pps sample 
    in Example 6.11 of Sampling:  Design and Analysis, 2nd ed. by Sharon L. Lohr,
    using Version 9.2 of SAS.
    Copyright 2008 Sharon L. Lohr*/

filename classpps 'C:\classpps.csv';
options ls=78 nodate nocenter;
 
data classes;
   input class clssize ;
   cards;
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


 /* Select a sample of size 5 with pps and without replacement, using
    the Hanurav-Vijayan method */
proc surveyselect data=classes out=worpl sampsize=5 method=pps jtprobs seed=75745;
   size clssize;
   id class;
proc print data=worpl;
run;

 /* Now let's enter the data for these classes */
 /* Note that we have to calculate the weights for each observation
    using both psu and ssu weight */

data classamp;
   infile classpps firstobs=2 delimiter=",";
   input class clssize finalwt y;
run;

  /* Since we do not select the psus as an SRS, I prefer to omit
     the total statement and use the following command.  This gives
     the values for the with-replacement variance in Example 6.11.
     If you include the total option in the command line for proc surveymeans,
     it calculates the fpc for an SRS of (1 - n/N); this is not correct for pps samples.

     The "sum of weights" in the data summary can help you tell if you
     calculated the weights incorrectly; it should in general estimate
     the total number of students (and will be exact for this example). */

proc surveymeans data=classamp mean sum clm clsum;
   cluster class;
   weight finalwt;
   var y;
run;
   

 /* Note that if you include the total number of psus in the 
    proc surveymeans statement, SAS calculates a pseudo-fpc
    by multiplying each variance by (1-n/N). This is only
    theoretically correct when the psus are selected using
    simple random sampling. */

proc surveymeans data=classamp total=15 mean sum clm clsum;
   cluster class;
   weight finalwt;
   var y;
run;


   
  
