/* Reads the data file nhanes.csv and produces Example 11.7 for Sampling: Design and Analysis, 2nd ed.
   by Sharon L. Lohr. Copyright 2009 Sharon Lohr */

options ovp nocenter;

filename nhanes  'C:\nhanes.csv';

data nhanes;
  infile nhanes delimiter=',' firstobs=2;
  input sdmvstra sdmvpsu wtmec2yr age ridageyr riagendr ridreth2 dmdeduc indfminc bmxwt bmxbmi bmxtri 
      bmxwaist bmxthicr  bmxarml;
  if riagendr = 1 then x = 0; /* x=0 is male*/
  if riagendr = 2 then x = 1; /* x=1 is female */
  one = 1;  
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

/* Using proc surveyreg to compare domain means */

/* First check that we recoded correctly */

proc surveyfreq data=nhanes missing;
   tables x;
run;

/* Good---we get the counts for males and females given in the NHANES codebook*/

proc surveyreg data=nhanes;
  stratum sdmvstra;
  cluster sdmvpsu;
  weight wtmec2yr;
  model bmxbmi = x/clparm;	
run;

/* We can also estimate the domain means in proc surveymeans.
   This will not give a test or CI for the differences of domain means. */

proc surveymeans data=nhanes;
  stratum sdmvstra;
  cluster sdmvpsu;
  weight wtmec2yr;
  domain x;
  var bmxbmi;	
run;

proc surveymeans data=nhanes;
  stratum sdmvstra;
  cluster sdmvpsu;
  weight wtmec2yr;
  domain riagendr;
  var bmxbmi;	
run;

