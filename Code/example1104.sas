/* Gives the output in Example 11.4 of Sampling: Design and Analysis, 2nd ed. 
   Copyright 2009 Sharon L. Lohr*/

options ovp nocenter nodate;
filename anthsrs "C:\anthsrs.csv";
filename anthuneq "C:\anthuneq.csv";

data anthsrs;
   infile anthsrs firstobs=2 delimiter=",";
   input finger height ;
   wt = 3000/200;
   one = 1;
run;

/* Find the linearization estimate of the variance for the data in anthsrs */

proc surveyreg data=anthsrs;
   weight wt;
   model height = finger / clparm;
run;

/* Fit the regression model for the unequal-probability sample with weights */

data anthuneq;
   infile anthuneq firstobs=2 delimiter=",";
   input finger height prob wt;
   one = 1;
run;

proc surveyreg data = anthuneq;
   weight wt;
   model height = finger/clparm;
   output out=regpred pred=predicted residual=resid; 
run;

/* Use the jackknife to estimate the variance */

proc surveyreg data = anthuneq varmethod=jk;
   weight wt;
   model height = finger/clparm;
   output out=regpred pred=predicted residual=resid; 
run;

