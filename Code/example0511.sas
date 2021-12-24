/* Analyzes the data in Example 5.11 of Sampling: Design and Analysis, 2nd ed.
   by S. Lohr 
   Copyright 2008 by Sharon Lohr */

filename cootsdat 'C:\coots.csv';

options ls=78 nodate nocenter;
data coots;
   infile cootsdat delimiter=',' firstobs=2;
   input clutch csize length breadth volume tmt;
   relwt = csize/2;

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
