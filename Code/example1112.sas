/* Reads the data file nhanes.csv and produces output in Example 11.12 of Sampling: Design and Analysis, 2nd ed.
   by Sharon L. Lohr. Copyright 2009 Sharon Lohr */

options ovp nocenter;

filename nhanes  'C:\nhanes.csv';

data nhanes;
  infile nhanes delimiter=',' firstobs=2;
  input sdmvstra sdmvpsu wtmec2yr age ridageyr riagendr ridreth2 dmdeduc indfminc bmxwt bmxbmi bmxtri 
      bmxwaist bmxthicr  bmxarml;
  bmigt25 = .;
  if bmxbmi > 25 then bmigt25 = 1;
  if bmxbmi le 25 and bmxbmi > 0 then bmigt25=0;
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

/* Run a logistic regression predicting bmigt25 from explanatory variables */
/* Note that some of the tests given by SAS are incorrect for survey data. */
/* Only the Wald chi-square test accounts for the survey design. */
/* The AIC and value of -2 log likelihood given in the output are
   based on the estimated likelihood function for the population.
   It is thus inappropriate to use them for inference with complex
   survey data. */

proc surveylogistic data=nhanes;
  stratum sdmvstra;
  cluster sdmvpsu;
  weight wtmec2yr;
  model bmigt25 (event='1')= bmxtri/covb ;	
run;

 /* Add a class variable for race/ethnicity */

proc surveylogistic data=nhanes;
  class ridreth2; 
  stratum sdmvstra;
  cluster sdmvpsu;
  weight wtmec2yr;
  model bmigt25 (event='1')= bmxtri ridreth2;	
run;

