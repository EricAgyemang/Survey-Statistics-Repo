 /* Analyzes the data in Example 5.4 of
   Sampling: Design and Analysis, 2nd ed. by S. Lohr 
   Copyright 2008 by Sharon Lohr */

options ls=78 nodate nocenter;
 
data gpa;
   input suite gpa;
   wt = 20;  /* every person has weight 100/5 = 20 */
   datalines;
1 3.08
1 2.60
1 3.44
1 3.04
2 2.36
2 3.04
2 3.28
2 2.68
3 2.00
3 2.56
3 2.52
3 1.88
4 3.00
4 2.88
4 3.44
4 3.64
5 2.68
5 1.92
5 3.28
5 3.20
;
proc print data=gpa;

proc boxplot data=gpa;
   plot gpa*suite;
run;

proc glm data=gpa;
   class suite;
   model gpa=suite;
run;
