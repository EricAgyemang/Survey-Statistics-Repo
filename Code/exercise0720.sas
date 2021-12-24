/* Reads data for Exercise 7.20 of
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

/* Construct a histogram for the bmi data */

/* proc gchart can draw histograms using weights.  
   Use the weight variable with the sumvar option.
   space=0 removes the spaces between the bars. */

goptions reset=all;
*goptions colors = (black);
axis1 label=(angle=90 'Relative Frequency');
axis4 label=('Body Mass Index') order=(10 to 70 by 10);

proc gchart data=nhanes;
   vbar bmxbmi  /  midpoints=  0 to 70 by 5 sumvar=wtmec2yr 
      space=0 raxis=axis1;
run;

/* To get a relative frequency histogram, need to divide by sum of weights */

data nhanes1;
   set nhanes;
   one=1;

proc means data=nhanes1 noprint;
   var 	wtmec2yr;
   output out=bmiwtsum  sum=sumwts n = numobs;
run;

data bmiwtsum;
   set bmiwtsum;
   one=1;
proc print data=bmiwtsum;
run;

data nhanes2 ;
  merge nhanes1 bmiwtsum;
  by one;
  relwt = wtmec2yr/(sumwts*10);	/*divide by sum of weights x bin width */

goptions reset=all;
*goptions colors = (black);
axis1 label=(angle=90 'Relative Frequency') order = (0 to 0.03 by 0.01);
axis4 label=('Body Mass Index') order=(10 to 70 by 10);

proc gchart data=nhanes2;
   vbar bmxbmi  /  midpoints=  0 to 70 by 5 sumvar=relwt 
      space=0 raxis=axis1;
run;



/* Construct a quantile-quantile plot for the bmi data */

/* First, sort the data and eliminate missings */
data nhanes1;
   set nhanes;
   if bmxbmi = . then delete;
   one=1;

proc sort data=nhanes1;
   by bmxbmi;
run;

proc means data=nhanes1 noprint;
   var 	wtmec2yr;
   output out=bmiwtsum  sum=sumwts n = numobs;
run;

data bmiwtsum;
   set bmiwtsum;
   one=1;
proc print data=bmiwtsum;
run;

data nhanes2 ;
  merge nhanes1 bmiwtsum;
  by one;
  retain cumsumwt 0;
  cumsumwt = wtmec2yr + cumsumwt;
  prob = ( cumsumwt*(1-0.375/_N_)) /(sumwts*(1 + .25/numobs));
   v = quantile('normal',prob);

proc print data=nhanes2 (obs=50);
  var bmxbmi wtmec2yr cumsumwt sumwts prob v;
run;

goptions reset=all;
goptions colors = (black);
symbol1 value=circle h=.5;
axis1 label=('Normal Quantiles');
axis4 label=(angle=90 'Body Mass Index') order=(10 to 70 by 10);

proc gplot data=nhanes2;
   plot bmxbmi * v/haxis=axis1 vaxis=axis4 ;
run;


