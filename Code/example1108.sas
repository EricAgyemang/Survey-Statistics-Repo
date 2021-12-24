/* Reads the data file nhanes.csv and produces output in Example 11.8 for Sampling: Design and Analysis, 2nd ed.
   by Sharon L. Lohr. Copyright 2009 Sharon Lohr */

options ovp nocenter;

filename nhanes  'C:\nhanes.csv';

data nhanes;
  infile nhanes delimiter=',' firstobs=2;
  input sdmvstra sdmvpsu wtmec2yr age ridageyr riagendr ridreth2 dmdeduc indfminc bmxwt bmxbmi bmxtri 
      bmxwaist bmxthicr  bmxarml;
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

/* Do an ANOVA of body mass index by race/ethnicity category */

proc surveyreg data=nhanes;
  class ridreth2;
  stratum sdmvstra;
  cluster sdmvpsu;
  weight wtmec2yr;
  model bmxbmi = ridreth2;	
  estimate 'compare white - black'	ridreth2 1 -1 0 0 0; 
    /* compare non-hispanic white & non-hispanic black */
  estimate 'compare Mexican American - Other Hispanic'	ridreth2 0 0 1 0 -1; 
    /* compare non-hispanic white & non-hispanic black */
    /* the other contrasts can be estimated similarly */
run;

/* Note that the estimated means of the race groups are the same as in
   a domain analysis with proc surveymeans, but we need to run 
   proc surveyreg as above to do the F test and compare means */

proc surveymeans data=nhanes;
  domain ridreth2;
  stratum sdmvstra;
  cluster sdmvpsu;
  weight wtmec2yr;
  var bmxbmi ;	
run;


/* Side by side boxplots, Fig. 11.6.  */

proc sort data=nhanes;
  by ridreth2;
run;

proc surveymeans data= nhanes mean percentile=(0 25 50 75 100) sumwgt;
  by ridreth2;
  stratum sdmvstra;
  cluster sdmvpsu;
  weight wtmec2yr;
  var bmxbmi ;
  ods output Statistics=ethstat;
run;

data quants;
  set ethstat;
  if ridreth2 = . then delete;
  bmxL = Pctl_0;
  bmx1 = Pctl_25;
  bmxX = Mean;
  bmxM = Pctl_50;
  bmx3 = Pctl_75;
  bmxH = Pctl_100;
  bmxS = StdErr;   /* Not the standard deviation, but we don't use this */
  bmxN = SumWgt;
run;

/*proc print data=quants;
run; */

goptions reset=all;
goptions colors = (black);
axis3 label=('Race/Ethnicity') value=(tick=1 "White"  justify=c "non-Hispanic"
            tick=2 "Black" 	justify=c "non-Hispanic"
            tick=3 "Mexican"  justify=c "American"
            tick=4 "Other" 	justify=c ""
            tick=5 "Other" justify=c "Hispanic");
axis4 label=(angle=90 'Body Mass Index') order=(10 to 70 by 10);

proc anom summary=quants;
   boxchart bmx*ridreth2 / nolimits boxwidth= 7 boxwidthscale=1 
            nolegend haxis = axis3 vaxis=axis4;
   /* boxwidthscale allows widths of boxes to vary proportionately to bmxN,
      which is the sum of the weights for observations in that box */
   /* npanelpos forces SAS to put all the boxes on the same page by
	  specifying the number of subgroup positions per panel */
run;


   
