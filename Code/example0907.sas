/* Analyzes the data in Example 5.6 of Sampling: Design and Analysis, 2nd ed.
   by Sharon L. Lohr 
   Copyright 2008 by Sharon L. Lohr */

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

 /* Now let's construct the jackknife weights and use jackknife to
    estimate the variance*/

proc surveymeans data=coots varmethod=jk(outweights=jkwt outjkcoefs=jkcoef);
   cluster clutch;
   var volume;
   weight relwt;
run;

proc print data=jkwt;
run;

proc print data=jkcoef;
run;
