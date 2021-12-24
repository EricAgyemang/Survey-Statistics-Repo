/* Reads the data file syc.csv and does calculations in Example 10.5 of
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
run;

/* What happens if we ignore the clustering ? */

proc freq data=syc;	  /* THIS IS WRONG---DON'T DO IT!!!!! */
  tables famtime * everviol	/chisq;
  weight finalwt;
run;

/* Use proc surveyfreq to perform Wald test for variables famtime and everviol. */

proc surveyfreq data=syc ;
  stratum stratum;
  cluster psu;
  weight finalwt;
  tables famtime*everviol/wchisq or ; 
run;
