/* Analyzes the data in Example 9.9 of Sampling: Design and Analysis, 2nd ed.
   using bootstrap.  The macro bootwt may be used for other data sets as well.
   Copyright 2009 Sharon L. Lohr */

options ls=78 nocenter nodate;
filename htstrat 'C:\htstrat.csv';

data htstrat;
   infile htstrat delimiter= ',' firstobs = 2;
   input rn height gender $;
   if gender = "F" then wt = 6.25;
   else if gender = "M" then wt = 25;
   if gender = "F" then gender1 =1;
   if gender = "M" then gender1 = 0;
   psuid = _N_;
run;

proc surveymeans data=htstrat mean percentile=(25 50 75);
	weight wt;
	stratum gender;	
    var height;
run;

/* As of this writing, SAS PROC SURVEYMEANS does not construct
   replicate weights for bootstrap. 
   The following macro will do this (albeit slowly!) */

%macro bootwt(fulldata,wt,stratvar,psuvar,numboot);

/* Author:  Sharon L. Lohr, 2008 */

/* Input
   fulldata	full data set name
   yval		name of response variable
   wt		name of weight variable
   stratvar name of stratification variable
   psuvar   name of psu variable
   numboot  number of bootstrap replicates desired */

/* Output
   repwt	name of array to contain bootstrap weights 
   fullrep  data set containing bootstrap weights */

/* Construct data set with list of strata and psus */

proc sort data=&fulldata;
   by &stratvar  &psuvar;
run;
proc means data=&fulldata noprint;
   by &stratvar &psuvar;
   var &psuvar;
   output out=psulist mean= psuvar;
run;

/*  Set stratum sample size to n_h - 1 */

proc freq data = psulist;
   tables &stratvar/out=numpsu;
run;

data numpsu (keep = &stratvar  _nsize_);
   set numpsu;
   _nsize_ = count-1;
run;

/* Select sample for first bootstrap weight */
/* %put replicate weight 1;	 */

proc surveyselect data=psulist method =  urs sampsize=numpsu out=repout outall;
   strata  &stratvar;
   id psuvar;
run;

data repout ;
   set repout;
   array repmult{&numboot} ; 
   repmult{1} =  NumberHits;
run;

/* Now repeat the calculation for each replicate*/

%do i=2 %to &numboot;  

proc surveyselect data=psulist method =  urs sampsize=numpsu out=repout2 outall;
   strata  &stratvar;
   id psuvar;
run;

data repout2 (keep=&stratvar psuvar NumberHits);
   set repout2;
run;

/* Now merge the data sets */
/* The array repmult contains the number of hits for each psu in the 
   bootstrap replicates. */

data repout; 
   merge repout repout2;
   by &stratvar psuvar;
   array repmult{&numboot};
   repmult{&i} = NumberHits;
run;

%end;

/* Ok, now we have a dataset repout with the number of hits for
   each bootstrap replicate.  Now we need to merge this data set
   with the original full data and multiply each original weight
   times the number of hits in repmult times (n_h/(n_h-1)). */

data fullrep;
   set &fulldata;
   psuvar = &psuvar;
run;

proc sort data=fullrep;
   by &stratvar psuvar;
run;

proc sort data=numpsu;
   by &stratvar;
run;

data fullrep (drop = _nsize_);
   merge fullrep numpsu;
   by &stratvar;
   wtmult = (_nsize_+1)/(_nsize_);
run;

proc sort data=repout;
   by &stratvar psuvar;
run;

data fullrep (drop=ExpectedHits NumberHits Selected SamplingWeight i);
   merge fullrep repout;
   by &stratvar psuvar;
   array repwt{&numboot};
   array repmult{&numboot};
   do i=1 to &numboot;
      repwt{i} = &wt * repmult{i} * wtmult;
   end;
run;

%mend bootwt;

%bootwt(htstrat,wt,gender,psuid,500);

proc print data=fullrep (obs=2); run; /* Look at the replicate weights*/


/* Now analyze the data using the bootstrap weights */

proc surveymeans data=fullrep varmethod = jk;
  var height;
  weight wt;
  repweights repwt1-repwt500/jkcoefs=0.002004008 df = 198;
run;

proc surveymeans data=fullrep mean percentile=(25 50 75);
  strata gender;
  var height;
  weight wt;
run;

/* Try with more replicates */

%bootwt(htstrat,wt,gender,psuid,1000);


proc surveymeans data=fullrep mean varmethod = jk;
  var height;
  weight wt;
  repweights repwt1-repwt1000/jkcoefs= 0.001001001 df = 198;
run;

/* Use bootstrap weights to estimate variance of median.
   Unfortunately, proc surveymeans will not do this yet,
   so we need to use a macro or concatenate the data sets. */

%macro bootmed(fullrep,yvar,wt,repwt,numboot);

   /* Input
   fullrep	full data set name
   yvar		name of response variable
   wt		name of weight variable	
   repwt	name of array containing replicate weights
   numboot  number of bootstrap replicates desired */

   /* Calculate estimate using replicate weight 1 */
%put replicate weight 1	;

/*proc print data=&fullrep (obs=2);
  var &repwt.1;  
run; */

proc surveymeans data=&fullrep all ;
   weight &repwt.1;
   var &yvar;
   ods output Statistics=outstat;
run; 

  /* Now do remaining iterations */

%do i=2 %to &numboot;  

proc surveymeans data=&fullrep all ;
   weight &repwt.&i;
   var &yvar;
   ods output Statistics=outstat2;
run; 
/* Now concatenate the data sets */
data outstat; 
   set outstat outstat2;
run;
%end;

/* Find the sample variance of the medians */

proc means data= outstat noprint;
   var  Pctl_50;
   output out=varmed mean=avgmed var=varmed;
run;

%mend bootmed;

%bootmed(fullrep,height,wt,repwt,1000);

proc print data=varmed;
run;

