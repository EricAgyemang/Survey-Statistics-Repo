/* This sas program provides the output in
    in Example 7.7 of Sampling:  Design and Analysis, 2nd ed. by Sharon L. Lohr,
    using Version 9.2 of SAS.  Copyright 2008 Sharon L. Lohr*/

options ovp nocenter nodate;
filename syc "C:\syc.csv";

/* Read in and analyze age variable from 1987 Survey of Youth in Custody */

data syc;
  infile syc firstobs=2 delimiter=",";
  input stratum facility facsize initwt finalwt randgrp age race ethnicty educ sex livewith    
      famtime crimtype everviol numarr  probtn  corrinst evertime prviol prprop prdrug  prpub   
      prjuv  agefirst  usewepn alcuse  everdrug;
  agesq = age*age;  /* Calculate age^2 so we can estimate S^2 for age */
  psu = facility;
  if stratum ge 6 then psu = _N_; /* Let psus in strata with 1 facility be individuals
                                     so that the strata contribute to the variability */
run;

proc print data=syc (obs=200);
run;

/* Calculate summary statistics for the variables of interest */

proc surveymeans data=syc mean clm percentile=(0 25 50 75 100) sum clsum;
  stratum stratum;
  cluster psu;
  weight finalwt;
  var age agesq;
  ods output Statistics=sycstat;
run;

proc print data=sycstat;
run;


