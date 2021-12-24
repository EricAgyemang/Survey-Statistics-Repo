/* Calculates the sampling distribution in Example 2.4 of Sampling: Design and Analysis,
   2nd ed., by Sharon L. Lohr.  Copyright 2009, Sharon L. Lohr */

filename samples "C:\samples.csv";

data samples;
   infile samples delimiter="," firstobs=2;
   input sampnum u1 u2 u3 u4 y1 y2 y3 y4 total;
   /* define variables that can be used to count the number of 7s */
   if y1 = 7 then numseven = 1; else numseven = 0; 
   if y2 = 7 then numseven = numseven + 1;
   if y3 = 7 then numseven = numseven + 1;
   if y4 = 7 then numseven = numseven + 1;
run; 

/* Find the frequency distribution of the 70 samples from the population in Example 2.2 */

proc freq data=samples;
   tables numseven;
run;
