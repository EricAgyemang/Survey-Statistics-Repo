/* Analyzes the data in Example 5.6 of Sampling: Design and Analysis, 2nd ed.
   by S. Lohr. Copyright 2008 by Sharon Lohr */

filename algebra 'C:\algebra.csv';

options ls=78 nocenter nodate;
data algebra;
   infile algebra delimiter= ',' firstobs = 2;
   input class Mi score;
   sampwt = 187/12;
run;

proc surveymeans data=algebra total = 187 nobs mean sum clm clsum df; 
   cluster class;
   var score;
   weight sampwt;
   ods output Statistics=myout;
run;

proc print data=myout;
run;

proc glm data = algebra;
   class class;
   model score = class;
   means class;
run;
