/* Does calculations for Example 10.1 of
   Sampling: Design and Analysis, 2nd ed.
   by Sharon L. Lohr. Copyright 2009 Sharon Lohr */

data cable;
   input computer $ cable $ count;
datalines;
n n	105
n y	88
y n	188
y y	119
;

proc freq data=cable;
  tables computer*cable/chisq expected measures;
  weight count;
run;
