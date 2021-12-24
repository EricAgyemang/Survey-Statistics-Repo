/* Gives the output in Example 11.3 of Sampling: Design and Analysis, 2nd ed. 
   Copyright 2009 Sharon L. Lohr*/

options ovp nocenter nodate;
filename anthsrs "C:\anthsrs.csv";
filename anthuneq "C:\anthuneq.csv";
filename anthrop "C:\anthrop.csv";

/* Calculate the OLS estimates for the population */

data anthpop;
   infile anthrop firstobs=2 delimiter=",";
   input finger height ;
run;

proc reg data = anthpop;
   model height = finger;
run;


/* Fit the regression model with weights */

data anthuneq;
   infile anthuneq firstobs=2 delimiter=",";
   input finger height prob wt;
   one = 1;
run;

proc surveyreg data = anthuneq;
   weight wt;
   model height = finger/clparm;
   output out=regpred pred=predicted residual=resid; 
run;

/*  Plot the data with the fitted regression line */

goptions reset=all;
goptions colors = (black);
axis1 label=('Left Middle Finger Length (cm)') order =  (10 to 13.5 by .5);
axis2 label=(angle=90 'Height (inches)') order=(55 to 75 by 5);
axis3  order=(55 to 75 by 5) major=none minor=none value=none;
symbol interpol=join width=2 color = black;


proc sort data=regpred;
   by finger height;
run;

proc means data=regpred noprint;
   by finger height;
   var 	wt predicted;
   output out=circlepred  sum=sumwgt sumpred mean = meanwt meanpred;
run;

proc print data=circlepred;
run;

/* Gives Fig 11.5 in book */

proc gplot data=circlepred;
   bubble height*finger=sumwgt/haxis=axis1 vaxis=axis2;
   plot2 meanpred*finger/haxis=axis1 vaxis =axis3 ;
run;

