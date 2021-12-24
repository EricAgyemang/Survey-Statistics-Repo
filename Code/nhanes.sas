/* Reads the data file nhanes.csv for Sampling: Design and Analysis, 2nd ed.
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

proc print data=nhanes (obs=20);
run;

/* Calculate summary statistics for the variables of interest */

proc surveymeans data=nhanes all;
  stratum sdmvstra;
  cluster sdmvpsu;
  weight wtmec2yr;
  var bmxbmi age;
  ods output Statistics=nhanesstat;
run;

proc print data=nhanesstat;
run;

/* Plot the raw data, without weights, producing Figure 7.15 */

goptions reset=all;
goptions colors = (black);
axis4 label=(angle=90 'Body Mass Index (kg/m^2)') order=(10 to 70 by 10);

proc gplot data=nhanes;
   plot bmxbmi*age/haxis = 0 to 90 by 10 vaxis = axis4; 
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

/* Plot a sample of points selected with probability proportional to 
   the weight. Shown in Figure 7.17. */

proc surveyselect data =nhanes method=pps_wr sampsize=500 out=ppsnhanes seed=52938;
   size  wtmec2yr;
run;

proc gplot data=ppsnhanes;
   plot bmxbmi*age/haxis = 0 to 90 by 10 vaxis = axis4; 
run;

/* Circle plot of data: Figure 7.18. */
/* First, create rectangles and sum weights in rectangles */

data groupage;
   set nhanes;
   bmigroup = round(bmxbmi,5);
   agegroup = round(age,5);
run;

proc sort data=groupage;
   by bmigroup agegroup;

proc means data=groupage;
   by bmigroup agegroup;
   var 	wtmec2yr;
   output out=circleage  sum=sumwts;
run;
   

goptions reset=all;
goptions colors = (black);
axis4 label=(angle=90 'Body Mass Index, rounded to 5') order=(10 to 70 by 10);

proc gplot data=circleage;
   bubble bmigroup * agegroup= sumwts/bsize=12 haxis = 0 to 90 by 10 vaxis = axis4;
   label agegroup = 'Age (years), rounded to 5';
run;

/* Can do a similar plot using shading rather than circles, Fig. 7.19 */
/* We create a data set for each rectangle where the shading is 
   proportional to the sum of the weights for points in that rectangle. 
   Since we can fill in the entire rectangle, we can have a finer grid
   for the shaded plot than for the weighted circle plot. */

/* First, create rectangles and sum the weights in the rectangles */

data groupage1;
   set nhanes;
   bmigroup = round(bmxbmi,1);
   agegroup = round(age,1);
run;

proc sort data=groupage1;
   by bmigroup agegroup;

proc means data=groupage1 noprint;
   by bmigroup agegroup;
   var 	wtmec2yr;
   output out=shadeage  sum=sumwts;
run;
proc print data=shadeage;
   var agegroup bmigroup sumwts;
run;

/* Adjust x and y so we have the shading we want */
/* The pattern statement in proc gcontour averages the z value for
   the four corners of the rectangle */
data shadeage;
   set shadeage;

goptions reset=all;
axis3 label=('Age (years)') order =  (0 to 90 by 10);
axis4 label=(angle=90 'Body Mass Index') order=(10 to 70 by 10);

proc gcontour data=shadeage incomplete;
   plot bmigroup*agegroup=sumwts /pattern haxis=axis3 vaxis=axis4 nolegend;
run;

/* Side by side boxplots, Fig. 7.20. SAS does not do this easily; we need to
   use a method similar to the one we used to construct side-by-side 
   boxplots of domains and trick proc surveymeans into giving us
   the percentiles for the x groups. */

proc sort data=groupage;
  by agegroup;
run;

proc surveymeans data= groupage mean percentile=(0 25 50 75 100) sumwgt;
  by agegroup;
  stratum sdmvstra;
  cluster sdmvpsu;
  weight wtmec2yr;
  var bmxbmi ;
  ods output Statistics=agegpstat;
run;

proc print data=agegpstat;
run;

data agequants;
  set agegpstat;
  if agegroup = . then delete;
  bmxL = Pctl_0;
  bmx1 = Pctl_25;
  bmxX = Mean;
  bmxM = Pctl_50;
  bmx3 = Pctl_75;
  bmxH = Pctl_100;
  bmxS = StdErr;   /* Not the standard deviation, but we don't use this */
  bmxN = SumWgt;
run;

proc print data=agequants;
run;

goptions reset=all;
goptions colors = (black);
axis3 label=('Age Group') order =  (0 to 85 by 5);
axis4 label=(angle=90 'Body Mass Index') order=(10 to 70 by 10);

proc anom summary=agequants;
   boxchart bmx*agegroup / nolimits boxwidth= 3 boxwidthscale=1 
            npanelpos = 100 nolegend haxis = axis3 vaxis=axis4;
   /* boxwidthscale allows widths of boxes to vary proportionately to bmxN,
      which is the sum of the weights for observations in that box */
   /* npanelpos forces SAS to put all the boxes on the same page by
	  specifying the number of subgroup positions per panel */
run;

/* Construct a plot with smoothed trend line, Figure 7.21. */
/* Other smoothing programs could also be used, as long as they
   allow you to incorporate the weights like proc loess does.
   Some other smoothing software allows more control over the bandwidth,
   which may be desirable for some applications. */

/* Do local linear regression in SAS */

ods graphics on;
proc loess data=nhanes;
   model bmxbmi=age / degree = 1 select=gcv;
   weight  wtmec2yr;
   ods output  OutputStatistics = bmxsmooth ;
run;
ods graphics off;

proc print data=bmxsmooth;
run;

proc sort data=bmxsmooth;
   by age;

   /*
data plotsmooth;
   set nhanes bmxsmooth;   concatenates the data sets */
run;


goptions reset=all;
goptions colors = (gray);
axis3 label=('Age (years)') order =  (0 to 90 by 10);
axis4 label=(angle=90 'Body Mass Index') order=(10 to 70 by 10);
axis5  order=(10 to 70 by 10) major=none minor=none value=none;
symbol interpol=join width=2 color = black;

/* Display the trend line with the weighted circle plot */

data plotsmth;
   set bubbleage bmxsmooth;	/* concatenates the data sets */
run;

proc gplot data=plotsmth;
   bubble bmxbmi * age= sumwts/bsize=10 haxis = axis3 vaxis = axis4;
   plot2 Pred*age/haxis = axis3 vaxis = axis5;
run;

/* Display the trend line with the subset of data (not shown in book) */

data bubblesmth;
   set circleage bmxsmooth;
   if Pred ne . then agegroup = age;

proc gplot data=bubblesmth;
   bubble bmigroup * agegroup= sumwts/bsize=12 haxis = axis3 vaxis = axis4;
    plot2 Pred*agegroup/haxis = axis3 vaxis = axis5;
run;

