/* Analyzes the data in Example 5.7 of Sampling: Design and Analysis, 2nd ed.
   by S. Lohr 
   Copyright 2008 by Sharon Lohr */

filename cootsdat 'C:\coots.csv';

options ls=78 nodate nocenter;
data coots;
   infile cootsdat delimiter=',' firstobs=2;
   input clutch csize length breadth volume tmt;
   relwt = csize/2;

 /*  For the coots data we do not know the number of units in population */
 /*  Must include the weight variable since observation units have
     unequal weights. Here we use the relative weights */

proc surveymeans data=coots;
   cluster clutch;
   var volume;
   weight relwt;
run;

 /* Construct the plot in Figure 5.3.  You can omit the goptions statements
    and the options in the plot statement if you wish to use the SAS plot defaults. */

goptions reset=all;
goptions colors = (black);
symbol1 value= dot h = .5;
axis4 label=(angle=90 'Egg Volume') order=(0 to 5 by 1);
axis3 label=('Clutch Number') order =  (0 to 200 by 50);

proc gplot data=coots;
   plot volume * clutch/ haxis = axis3 vaxis = axis4;
run;

 /* Draw the plot in Figure 5.4.   */

/* Calculate the ANOVA table used in Example 5.11. */

proc glm data = coots;
   class clutch;
   model volume = clutch;
   means clutch;
   output out=meanout predicted = pred;
run;

proc sort data=meanout;
   by pred;
run;

proc print data=meanout;
run;

/* proc mixed analysis for Example 5.14 */

proc mixed data=coots;
   class clutch;
   model volume = /solution;
   random clutch;
run;

