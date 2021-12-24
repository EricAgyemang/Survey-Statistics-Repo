/* Creates the output in Example 11.6 of Sampling: Design and Analysis, 2nd ed.
   by Sharon L. Lohr. Copyright 2009 Sharon Lohr */

options ovp nocenter;
filename nhanes  'C:\nhanes.csv';

data nhanes;
  infile nhanes delimiter=',' firstobs=2;
  input sdmvstra sdmvpsu wtmec2yr age ridageyr riagendr ridreth2 dmdeduc indfminc bmxwt bmxbmi bmxtri 
      bmxwaist bmxthicr  bmxarml;
  agesq = age*age;  /* Create age-squared variable for quadratic model */
  logbmi = log(bmxbmi);
  if riagendr = 1 then x = 0; /* x=0 is male*/
  if riagendr = 2 then x = 1; /* x=1 is female */
  if age ge 15 then over15 = 1;
  else if age lt 15 then over15 = 0;
  else over15=.;
  one = 1;  
  label age = "Age at Examination (years)"
        agesq = "Age^2"
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

data over15;
   set nhanes;
   if over15 = 1;

/* Do a quadratic regression of bmxbmi vs. age, for full data */

proc surveyreg data=nhanes;
  stratum sdmvstra;
  cluster sdmvpsu;
  weight wtmec2yr;
  model bmxbmi = age agesq/clparm;	
  output out=quad pred=quadpred residual=quadres; 
  ods output ParameterEstimates = quadcoefs; 
run;


/* Do a weighted bubble plot of data. This gives Figure 7.16. */

proc sort data=nhanes;
   by bmxbmi age;

   /* You need to find sum of weights for each point first.
      Otherwise, SAS just shows the largest weight in each bubble */

proc means data=nhanes noprint;
   by bmxbmi age;
   var 	wtmec2yr;
   output out=bubbleage  sum=sumwts;
run;
   
goptions reset=all;
goptions colors = (black);
axis4 label=(angle=90 'Body Mass Index') order=(10 to 70 by 10);
axis3 label=('Age (years)') order =  (0 to 90 by 10);

proc gplot data=bubbleage;
   bubble bmxbmi * age= sumwts/bsize=10 haxis = axis3 vaxis = axis4;
run;

/* Plot the fitted regression line on the weighted bubble plot from Fig 7.16. */

goptions reset=all;
goptions colors = (gray);
axis3 label=('Age (years)') order =  (0 to 90 by 10);
axis4 label=(angle=90 'Body Mass Index') order=(10 to 70 by 10);
axis5  order=(10 to 70 by 10) major=none minor=none value=none;
symbol interpol=join width=2 color = black;

/* You have to sort the file of predicted values by age to draw
   the fitted line on the data plot.  Otherwise, SAS draws lines
   between successive points and it's a mess. Try it without the
   proc sort if you don't believe me. Also, you need to sum the
   weights for each value of age, bmxbmi. */

proc sort data=quad;
   by  age bmxbmi;

   /* You need to find sum of weights for each point first.
      Otherwise, SAS just shows the largest weight in each bubble */

proc means data=quad noprint;  /* make sure you use noprint so it's faster*/
   by age bmxbmi;
   var 	wtmec2yr quadpred quadres;
   output out=quadplot  sum=sumwts sumquad sumres mean=meanwt meanquad meanres;
run;
   
proc gplot data=quadplot;
   bubble bmxbmi*age= sumwts/bsize=10 haxis = axis3 vaxis = axis4;
   plot2 meanquad*age/haxis=axis3 vaxis=axis5;
run;

/* Plot residuals vs predicted values */

goptions reset=all;
goptions colors = (gray);
axis3 label=('Predicted Values') order =  (15 to 30 by 5);
axis4 label=(angle=90 'Residuals') order=(-20 to 40 by 10);
axis5  order=(10 to 70 by 10) major=none minor=none value=none;

proc gplot data=quadplot;
   bubble meanres*meanquad= sumwts/haxis = axis3 vaxis = axis4;
run;

/* The plot indicates that a quadratic model is not appropriate for the
   entire range of weights. Let's look at regression for only people over age 15 */

proc surveyreg data=nhanes;
  stratum sdmvstra;
  cluster sdmvpsu;
  weight wtmec2yr;
  domain over15;
  model bmxbmi = age agesq/clparm;	
  output out=quad pred=quadpred residual=quadres; 
  ods output ParameterEstimates = quadcoefs; 
run;

/* Since each psu has people from both domains, in this case the following gives the 
   same result.  In general, however, you want to use the domain statement to get
   the correct standard errors.  */

proc surveyreg data=over15;
  stratum sdmvstra;
  cluster sdmvpsu;
  weight wtmec2yr;
  model bmxbmi = age agesq/clparm;	
  output out=quad pred=quadpred residual=quadres; 
  ods output ParameterEstimates = quadcoefs; 
run;


proc sort data=quad;
   by  age bmxbmi;

proc means data=quad noprint;  /* make sure you use noprint so it's faster*/
   by age bmxbmi;
   var 	wtmec2yr quadpred quadres;
   output out=quadplot  sum=sumwts sumquad sumres mean=meanwt meanquad meanres;
run;
   
goptions reset=all;
goptions colors = (gray);
axis3 label=('Age (years)') order =  (0 to 90 by 10);
axis4 label=(angle=90 'Body Mass Index') order=(10 to 70 by 10);
axis5  order=(10 to 70 by 10) major=none minor=none value=none;
symbol interpol=join width=2 color = black;

proc gplot data=quadplot;
   bubble bmxbmi*age= sumwts/bsize=10 haxis = axis3 vaxis = axis4;
   plot2 meanquad*age/haxis=axis3 vaxis=axis5;
run;

/* Plot residuals vs predicted values */

goptions reset=all;
goptions colors = (gray);
axis3 label=('Predicted Values') order =  (22 to 30 by 2);
axis4 label=(angle=90 'Residuals') order=(-20 to 40 by 10);
axis5  order=(10 to 70 by 10) major=none minor=none value=none;

proc gplot data=quadplot;
   bubble meanres*meanquad= sumwts/haxis = axis3 vaxis = axis4;
run;


/* There is a large spread in the values of bmxbmi for each age, and that shows
   up as a funnel shape in the residuals vs. predicted values plot.
   Sometimes a log transformation helps in this situation.
   Do regression with response logbmi */

proc surveyreg data=nhanes;
  stratum sdmvstra;
  cluster sdmvpsu;
  weight wtmec2yr;
  model logbmi = age agesq/clparm;	
  output out=quad pred=quadpred residual=quadres; 
  ods output ParameterEstimates = quadcoefs; 
run;

/* Do a weighted bubble plot of data for response logbmi, with fitted regression curve */

proc sort data=nhanes;
   by logbmi age;

   /* You need to find sum of weights for each point first.
      Otherwise, SAS just shows the largest weight in each bubble */

proc means data=nhanes noprint;
   by logbmi age;
   var 	wtmec2yr;
   output out=bubbleage  sum=sumwts;
run;
   
goptions reset=all;
goptions colors = (black);
axis4 label=(angle=90 'Log Body Mass Index') order=(2 to 5 by 0.5);
axis3 label=('Age (years)') order =  (0 to 90 by 10);

proc gplot data=bubbleage;
   bubble logbmi * age= sumwts/bsize=10 haxis = axis3 vaxis = axis4;
run;


proc sort data=quad;
   by  age logbmi;

   /* You need to find sum of weights for each point first.
      Otherwise, SAS just shows the largest weight in each bubble */

proc means data=quad noprint;  /* make sure you use noprint so it's faster*/
   by age logbmi;
   var 	wtmec2yr quadpred quadres;
   output out=quadplot  sum=sumwts sumquad sumres mean=meanwt meanquad meanres;
run;
   
goptions reset=all;
goptions colors = (gray);
axis3 label=('Age (years)') order =  (0 to 90 by 10);
axis4 label=(angle=90 'Log Body Mass Index') order=(2 to 5 by 0.5);
axis5  order=(10 to 70 by 10) major=none minor=none value=none;
symbol interpol=join width=2 color = black;

proc gplot data=quadplot;
   bubble logbmi*age= sumwts/bsize=10 haxis = axis3 vaxis = axis4;
   plot2 meanquad*age/ vaxis=axis4;
run;

/* Plot residuals vs predicted values */

goptions reset=all;
goptions colors = (gray);
axis3 label=('Predicted Values') order =  (1 to 5 by 1);
axis4 label=(angle=90 'Residuals') order=(-.5 to .5 by .1);
axis5  order=(10 to 70 by 10) major=none minor=none value=none;

proc gplot data=quadplot;
   bubble meanres*meanquad= sumwts/bsize=15;/* haxis = axis3 vaxis = axis4;	*/
run;

/* Look at log(bmxbmi) for persons over age 15 */

proc surveyreg data=over15;
  stratum sdmvstra;
  cluster sdmvpsu;
  weight wtmec2yr;
  model logbmi = age agesq/clparm;	
  output out=quad pred=quadpred residual=quadres; 
  ods output ParameterEstimates = quadcoefs; 
run;

goptions reset=all;
goptions colors = (black);
axis4 label=(angle=90 'Log Body Mass Index') order=(2 to 5 by 0.5);
axis3 label=('Age (years)') order =  (15 to 90 by 10);

proc sort data=quad;
   by  age logbmi;

proc means data=quad noprint;  /* make sure you use noprint so it's faster*/
   by age logbmi;
   var 	wtmec2yr quadpred quadres;
   output out=quadplot  sum=sumwts sumquad sumres mean=meanwt meanquad meanres;
run;
   
goptions reset=all;
goptions colors = (gray);
axis3 label=('Age (years)') order =  (0 to 90 by 10);
axis4 label=(angle=90 'Log Body Mass Index') order=(2 to 5 by 0.5);
axis5  order=(10 to 70 by 10) major=none minor=none value=none;
symbol interpol=join width=2 color = black;

proc gplot data=quadplot;
   bubble logbmi*age= sumwts/bsize=10 haxis = axis3 vaxis = axis4;
   plot2 meanquad*age/ vaxis=axis4;
run;

/* Plot residuals vs predicted values */

goptions reset=all;
goptions colors = (gray);
axis3 label=('Predicted Values') order =  (1 to 5 by 1);
axis4 label=(angle=90 'Residuals') order=(-.5 to .5 by .1);
axis5  order=(10 to 70 by 10) major=none minor=none value=none;

proc gplot data=quadplot;
   bubble meanres*meanquad= sumwts/bsize=15;/* haxis = axis3 vaxis = axis4;	*/
run;
