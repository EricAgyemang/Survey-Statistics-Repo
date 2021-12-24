/* Reads the data file nhanes.csv and does calculations in Example 9.5 of
   Sampling: Design and Analysis, 2nd ed.
   by Sharon L. Lohr. Copyright 2009 Sharon Lohr */

options ovp nocenter;

filename nhanes  'C:\nhanes.csv';

data nhanes;
  infile nhanes delimiter=',' firstobs=2;
  input sdmvstra sdmvpsu wtmec2yr age ridageyr riagendr ridreth2 dmdeduc indfminc bmxwt bmxbmi bmxtri 
      bmxwaist bmxthicr  bmxarml;
  label age = "Age at Examination (years)"
        riagendr = "Gender"
        ridreth2 = "Race/Ethnicity"
        dmdeduc = "Education Level"
        indfminc = "Family income"
        bmxwt = "Weight (kg)"
        bmxbmi = "Body mass index"
        bmxtri = "Triceps skinfold (mm)"
        bmxwaist = "Waist circumference (cm)"
        bmxthicr = "Thigh circumference (cm)"
        bmxarml = "Upper arm length (cm)";	 
run;

/* Calculate summary statistics for the variables of interest */

proc surveymeans data=nhanes mean clm percentile=(25 50 75);
  stratum sdmvstra;
  cluster sdmvpsu;
  weight wtmec2yr;
  var bmxbmi ;
  ods output Statistics=nhanesstat;
run;

proc print data=nhanesstat;
run;

/* Now do the analysis creating replicate weights */

proc surveymeans data=nhanes mean clm varmethod=brr( outweights=repwts printh);
  stratum sdmvstra;
  cluster sdmvpsu;
  weight wtmec2yr;
  var bmxbmi ;
  ods output Statistics=nhanesstatbrr;
run;

proc print data=nhanesstatbrr;
run;


proc print data=repwts (obs=20);
   var sdmvstra sdmvpsu bmxbmi wtmec2yr RepWt_1-RepWt_16;  
run;

/* Find the median and its standard error using BRR replicate weights.
   SAS 9.2 does not yet do this with BRR in proc surveymeans, so I wrote
   a macro to calculate the median for each of the replicate weights.*/

%macro brrquant(fulldata,yval,wt,repwt,numreps,myreps,myoutput);

/* Input
   fulldata	full data set name
   yval		name of response variable
   wt		name of weight variable
   repwt	name of array containing brr weights
   numreps	number of replicate weights provided */

proc means data=&fulldata noprint;
   var &yval;
   weight &wt;
   output out=fullout mean=fullmean p25=fullp25 p50=fullp50 p75=fullp75;
run;
data fullout;
   set fullout;
   one=1;
run;

/* Do calcs for first jackknife weight */
%put replicate weight 1;

proc means data=&fulldata noprint;
   var &yval;
   weight &repwt.1;
   output out=repout mean=repmean p25=repp25 p50=repp50 p75=repp75;
run;

/* Now repeat the calculation for each replicate weight */

%do i=2 %to &numreps;  
%put replicate weight &i;
proc means data=&fulldata noprint;
   var &yval;
   weight &repwt.&i;
   output out=repout2 mean=repmean p25=repp25 p50=repp50 p75=repp75;
run;
/* Now concatenate the data sets */
data repout; 
   set repout repout2;
   one=1;
run;
%end;

data &repoutput;
   set repout;

data calcse; 
   merge repout fullout;
   by one;
   sqdmean =(repmean-fullmean)*(repmean-fullmean);
   sqdp25 = (repp25-fullp25)*(repp25-fullp25); 
   sqdp50 = (repp50-fullp50)*(repp50-fullp50); 
   sqdp75 = (repp75-fullp75)*(repp75-fullp75);
run;
proc means data=calcse noprint;
   var fullmean fullp25 fullp50 fullp75 sqdmean sqdp25 sqdp50 sqdp75;
   output out=&myoutput mean=fullmean fullp25 fullp50 fullp75 meanvar p25var p50var p75var;
run;
%mend brrquant;

%brrquant(repwts,bmxbmi,wtmec2yr,RepWt_,16,repout,calcvar);

proc print data=repout; run;

proc print data=calcvar; run;


