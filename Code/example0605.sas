 /* This SAS program will produce the estimates in Example 6.5
    of Sampling:  Design and Analysis 2nd ed. by Sharon L. Lohr,
    Copyright (c) Sharon L. Lohr, 2008 */

filename statepop 'C:\statepop.csv';

options ls=78 nodate nocenter;
 
data statepop;
   infile statepop delimiter=',' firstobs=2;
   input state $ county $ landarea popn physicns farmpop numfarm farmacre 
        veterans percviet;
   psii = popn/255077536;
   tioverpsi = physicns/psii;
   wt = 1/(100*psii);  /* weight = 1/(n \psi_i) */

   /* Be careful when constructing your dataset that if a psu is
      selected multiple times, then it appears that many times
      in the data.  Otherwise, you will get the wrong estimate. */
   
/* Produce the plot in Figure 6.1(a) */

proc gplot data=statepop;
   plot physicns*psii;
run;

/* Produce the plot in Figure 6.1(b) */

proc univariate data=statepop noprint;
   var tioverpsi;
   histogram tioverpsi / midpoints = 100000 to 2900000 by 200000 ;
run;

proc print data=statepop;

 /* We omit the 'total' option because sampling is with replacement */
 
proc surveymeans data=statepop nobs mean sum clm clsum;
   var physicns;
   weight wt;
run;

/* Note that estimating the sum for the variable 'one' gives an estimator
   of the total number of counties in the U.S., from the sample.  
   You'll notice that the 95\% CI contains the true value for this sample. */

data statepop;
   set statepop;
   one = 1;

proc surveymeans data=statepop nobs mean sum clm clsum;
   var one;
   weight wt;
run;
