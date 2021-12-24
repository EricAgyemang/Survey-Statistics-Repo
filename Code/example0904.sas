/* This sas program provides the output in
    in Example 9.4 of Sampling:  Design and Analysis, 2nd ed. by Sharon L. Lohr,
    using Version 9.2 of SAS.  Copyright 2008 Sharon L. Lohr*/

options ovp nocenter nodate;
filename syc "C:\syc.csv";

/* Read in and analyze age variable from 1987 Survey of Youth in Custody */

data syc;
  infile syc firstobs=2 delimiter=",";
  input stratum facility facsize initwt finalwt randgrp age race    ethnicty  educ sex livewith    
      famtime crimtype everviol numarr  probtn  corrinst evertime prviol  prprop prdrug  prpub   
      prjuv  agefirst  usewepn alcuse  everdrug;
  psu = facility;
  if stratum ge 6 then psu = _N_; /* Let psus in strata with 1 facility be individuals
                                     so that the strata contribute to the variability */
run;

proc print data=syc (obs=200);
run;

/* Calculate summary statistics for the variables of interest. Use the
   formulas to estimate the variance. */

proc surveymeans data=syc mean clm percentile=(0 25 50 75 100) sum clsum ;
  stratum stratum;
  cluster psu;
  weight finalwt;
  var age ;
  ods output Statistics=sycstat;
run;

proc print data=sycstat;
run;

/* Use the \random group method to estimate variance of mean age */

proc sort data=syc;
   by randgrp;

proc surveymeans data=syc mean clm percentile=(0 25 50 75 100) sum clsum ;
  by randgrp;
  weight finalwt;
  var age ;
  ods output Statistics=sycrgp;
run;

proc print data=sycrgp;
run;

proc univariate data=sycrgp; /* Calculate mean and variance of thetas */
   var Mean;
run;

/* Now use the jackknife to estimate the variance. Note that we cannot
   use the jackknife to estimate the variance of a percentile*/

proc surveymeans data=syc mean clm sum clsum varmethod=jk(outweight=jkwt outjkcoef=jkcoef);
  stratum stratum;
  cluster psu;
  weight finalwt;
  var age ;
  ods output Statistics=sycstat;
run;

proc print data=jkcoef (obs=100);
run;
