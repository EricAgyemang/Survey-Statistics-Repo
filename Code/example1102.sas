/* Gives the output in Example 11.2 of Sampling: Design and Analysis, 2nd ed. 
   Copyright 2009 Sharon L. Lohr*/

options ovp nocenter nodate;
filename anthsrs "C:\anthsrs.csv";
filename anthuneq "C:\anthuneq.csv";

data anthsrs;
   infile anthsrs firstobs=2 delimiter=",";
   input finger height ;
   wt = 3000/200;
   one = 1;
run;

/* Do a model-based analysis of the SRS */

proc reg data = anthsrs;
   model height = finger/ clb;
   output out=regpred pred=predicted residual=resid; 
run;

/* Plot the data */

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
   var 	one predicted resid;
   output out=circlepred  sum=sumn sumpred sumresid mean = meanone meanpred meanresid;
run;

/* proc print data=circlepred;
run;  */

/* Gives Fig 11.1 in book */

proc gplot data=circlepred;
   bubble height*finger=sumn/haxis=axis1 vaxis=axis2;
   plot2 meanpred*finger/ vaxis =axis3 ;
run;

/* Plot residuals vs. predicted values. Gives Figure 11.2. */

goptions reset=all;
goptions colors = (black);
axis1 label=('Predicted Value') order =  (60 to 70 by 2);
axis2 label=(angle=90 'Residual') order=(-5 to 5 by 1);

proc gplot data=circlepred;
   bubble meanresid*meanpred=sumn/haxis=axis1 vaxis=axis2;
run;


/* Calculate the OLS regression line for the unequal-probability sample
   in anthuneq.csv.  This line is inappropriate because it ignores
   the unequal weights. */

data anthuneq;
   infile anthuneq firstobs=2 delimiter=",";
   input finger height prob wt;
   one = 1;
run;


/* What happens when we ignore the weights? */
/* Don't do this in practice! */

proc reg data = anthuneq;  /* WRONG, WRONG, WRONG!!! Don't do this! */
   model height = finger;
   output out=regpred pred=predicted residual=resid; 
run;

/* Plot the data, ignoring the weights */

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
   var 	one predicted;
   output out=circlepred  sum=sumn sumpred mean = meanone meanpred;
run;

proc print data=circlepred;
run;

/* Gives Fig 11.3 in book */

proc gplot data=circlepred;
   bubble height*finger=sumn/haxis=axis1 vaxis=axis2;
   plot2 meanpred*finger/haxis=axis1 vaxis =axis3 ;
run;


/* Here's the correct analysis. See example1103.sas */

proc reg data = anthuneq;
   weight wt;
   model height = finger/clparm;
   output out=regpred pred=predicted residual=resid; 
run;

/* Use the jackknife to estimate the variance */

proc surveyreg data = anthuneq varmethod=jk;
   weight wt;
   model height = finger/clparm;
   output out=regpred pred=predicted residual=resid; 
run;


/*  Plot the data with the fitted regression line */

/* Plot the data, ignoring the weights */

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
   plot2 meanpred*finger/ vaxis =axis3 ;
run;

