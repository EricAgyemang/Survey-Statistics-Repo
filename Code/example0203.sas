/* Reads the data in file 'samples.csv' (Example 2.2) and draws a histogram. For use with
   Sampling: Design and Analysis, 2nd ed., by Sharon L. Lohr. Copyright 2009, Sharon L. Lohr   */

filename samples "C:\samples.csv";

data samples;
   infile samples delimiter="," firstobs=2;
   input sampnum u1 u2 u3 u4 y1 y2 y3 y4 total;
run; 

/* Find the frequency distribution of the 70 samples from the population in Example 2.2 */

proc freq data=samples;
   tables total;
run;

/* Draw a histogram of the totals from the 70 samples */


goptions reset=all;
goptions colors = (black);
axis1 label=(angle=90 'Frequency');
axis4 label=('Total from sample') ;

proc gchart data=samples;
   vbar total  /   midpoints=  22 to 58 by 2 
      space=0 raxis=axis1;
run;
