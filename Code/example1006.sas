/* Reads the data file syc.csv and does calculations in Example 10.6 of
   Sampling: Design and Analysis, 2nd ed.
   by Sharon L. Lohr. Copyright 2009 Sharon Lohr */

options ovp nocenter nodate;
filename syc "C:\syc.csv";

proc format;
   value everviolfmt 1 = 'yes'
                     0 = 'no'; 
   value  famtimefmt 1 = 'yes'
                     2 = 'no'
					 7 = 'dont know'
					 9 = 'missing';


/* Read data 1987 Survey of Youth in Custody */

data syc;
  infile syc firstobs=2 delimiter=",";
  input stratum facility facsize initwt finalwt randgrp age race    ethnicty  educ sex livewith    
      famtime crimtype everviol numarr  probtn  corrinst evertime prviol  prprop prdrug  prpub   
      prjuv  agefirst  usewepn alcuse  everdrug;
  psu = facility;
  if stratum ge 6 then psu = _N_; /* Let psus in strata with 1 facility be individuals
                                     so that the strata contribute to the variability */
  if famtime = 9 or famtime = 7 then famtime=.;   /* Recode missing values */
  if everviol = 9 then everviol = .;
  format everviol everviolfmt.;
  format famtime famtimefmt.;
   /* construct the variables for example 10.6 */
  if crimtype = 1 then currviol = 1;
    else currviol = 0;
  if crimtype = 2 then currprop = 1;
    else currprop = 0;
  if age le 15 then ageclass1 = 1; 
    else ageclass1 = 0;
  if age = 16 or age = 17 then ageclass2 = 1;
    else ageclass2 = 0;
  if age ge 18 then ageclass3 = 1;
    else ageclass3 = 0;
  if ageclass1 = 1 then ageclass = 1;
    else if ageclass2 = 1 then ageclass = 2;
	else ageclass = 3;
run;

  
/* Do Rao-Scott test for Example 10.6. */

proc surveyfreq data=syc ;
  stratum stratum;
  cluster psu;
  weight finalwt;
  tables currviol * (ageclass)/	wchisq chisq chisq1 lrchisq lrchisq1 deff or ;
run;



proc surveyfreq data=syc ;
  stratum stratum;
  cluster psu;
  weight finalwt;
  tables  currprop * (ageclass1 ageclass2)/	wchisq chisq chisq1 lrchisq lrchisq1 deff or expected;
run;



proc surveyfreq data=syc ;
  stratum stratum;
  cluster psu;
  weight finalwt;
  tables  currprop * (ageclass)/	wchisq chisq chisq1 lrchisq lrchisq1 deff or;
run;


proc surveyfreq data=syc ;
  stratum stratum;
  cluster psu;
  weight finalwt;
  tables  famtime * (currviol currprop)/	wchisq chisq chisq1 lrchisq lrchisq1 deff or;
run;



/* Use random group method to estimate variance of mean age */

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
