/* Analyzes the data in Example 5.14 of Sampling: Design and Analysis, 2nd ed.
   by S. Lohr 
   Copyright 2008 by Sharon Lohr */

filename cootsdat 'C:\coots.csv';

options ls=78 nodate nocenter;
data coots;
   infile cootsdat delimiter=',' firstobs=2;
   input clutch csize length breadth volume tmt;

/* Construct the plot in Figure 5.10 */

proc sort data = coots;
   by clutch;
proc means data=coots noprint;
   by clutch;
   var csize volume;
   output out=meanout mean = Mi meanvol;
proc print data=meanout;
run;

data meanout;
   set meanout;
   totalvol = meanvol * Mi;

goptions reset=all;
goptions colors = (black);
symbol1 value= dot h = .5;
axis4 label=(angle=90 'Estimated Total of Egg Volumes for Clutch') order=(0 to 60 by 10);
axis3 label=('Clutch Number') order =  (4 to 14 by 2);

proc gplot data=meanout;
   plot totalvol * Mi/ haxis = axis3 vaxis = axis4;
run;

/* proc mixed analysis for Example 5.14 */

proc mixed data=coots;
   class clutch;
   model volume = /solution;
   random clutch;
run;

