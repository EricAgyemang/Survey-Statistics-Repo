 /* This sas program analyzes the with-replacement pps sample 
    in Example 6.14 of Sampling:  Design and Analysis, 2nd ed. by Sharon L. Lohr,
    using Version 9.2 of SAS.
    Copyright 2008 Sharon L. Lohr*/

filename audit 'C:\auditresult.csv';
options ls=78 nodate nocenter;
 
data audit;
   infile audit delimiter="," firstobs=2;
   input account bookval psi auditval;
   wt = 1/(psi*25);	  /* weight = 1/(n psi) */
   overstate = bookval - auditval;

proc print data=audit;
run;

/* This is a with-replacement sample; do not use the total option */

proc surveymeans data=audit mean sum clm clsum;
   weight wt;
   var overstate;
run;
   
