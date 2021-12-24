/* Does calculations for Example 10.2 of
   Sampling: Design and Analysis, 2nd ed.
   by Sharon L. Lohr. Copyright 2009 Sharon Lohr */

data nurses;
   input stratum respond $ count;
datalines;
1 n 46
1 y 222
2 n 41
2 y 109
3 n 17
3 y 40
4 n 8
4 y 26
;

proc freq data=nurses;
  tables stratum*respond/chisq;
  weight count;
run;
