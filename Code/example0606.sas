/* This sas program will produce the estimates in Example 6.8
    of Sampling:  Design and Analysis 2nd ed. by Sharon L. Lohr,
    Copyright (c) Sharon L. Lohr, 2008 */

options ls=78 nodate nocenter;
 
data students;
   input class popMi sampmi hours;
   studentwt = (647/(popMi*5)) * (popMi/sampmi);
   datalines;
12   24 5 2
12   24 5 3
12   24 5 2.5
12   24 5 3
12   24 5 1.5
141 100 5 2.5
141 100 5 2
141 100 5 3
141 100 5 0
141 100 5 0.5
142 100 5 3
142 100 5 0.5
142 100 5 1.5
142 100 5 2
142 100 5 3
5    76 5 1
5    76 5 2.5
5    76 5 3
5    76 5 5
5    76 5 2.5
1    44 5 4
1    44 5 4.5
1    44 5 3
1    44 5 2
1    44 5 5
;

 /* Class 14 is sampled twice; to calculate the variance correctly, we renumber the
    first occurrence of class 14 as class 141, and the second occurrence as class 142.
    We count these as two separate psus in the estimation. 
    If you labeled both as 14, SAS would treat that as one psu with m_i = 10.*/

 /* Note that it's important how you enter weights here; we want to sum w_{ij} y_{ij},
    so we use a weight of (1/(n \psi_i)) (M_i/m_i) =  ((sum of Mi)/(n M_i)) x (M_i/m_i).
    Here, it simplifies to weight 647/25 since it's a self-weighting sample.
    For many problems, defining the weights is the trickiest part and it
    is also the most important. */

proc print data=students;

 /* We omit the 'total' option because sampling is with replacement */
 /* Important:  You need the weight statement AND the cluster statement for PROC
    SURVEYMEANS to calculate the total and variance correctly */

proc surveymeans data=students nobs mean sum clm clsum;
   weight studentwt;
   cluster class;
   var hours;
run;



