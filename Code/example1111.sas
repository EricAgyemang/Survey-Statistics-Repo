/* SAS code for performing the logistic regression in Example 11.11 
   of Sampling: Design and Analysis, 2nd ed. by Sharon L. Lohr
   Copyright 2008 Sharon Lohr*/

data cable;
   input cable computer count;
datalines;
1 1 119
0 1 88
1 0 188
0 0 105
;

proc freq data=cable;
   tables cable*computer/all; 
   weight count;
run;

proc logistic data=cable;
   model computer(event='1') = cable;
   weight count;
run;
