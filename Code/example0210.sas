/* Analyzes the data in Examples 2.5, 2.6, 2.7, and 2.10 of Sampling: Design and Analysis, 2nd edition
   by Sharon L. Lohr 
   Copyright 2009 by Sharon Lohr */

filename agsrs 'C:\agsrs.csv';
options ls=78 nodate;

data agsrs;
   infile agsrs dsd delimiter= ','  firstobs = 2;
     /* The dsd option allows SAS to read missing values between successive delimiters */ 
   input county $ state $ acres92 acres87 acres82 farms92
                          farms87 farms82 largef92 largef87
                          largef82 smallf92 smallf87 smallf82;
   if acres92 < 200000 then lt200k = 1;
      else if acres92 >= 200000 then lt200k = 0; /*  counties with fewer than 200000 acres in farms */
   if acres92 = -99 then acres92 =  . ;  /* check for missing values */
   if acres92 = -99 then lt200k =  . ;
   sampwt = 3078/300;  /* sampling weight is same for each observation */

   /* Draw a histogram of the data */

proc univariate data = agsrs noprint;
   histogram acres92 ;

 /* proc surveymeans calculates summary statistics, and adjusts for fpc. */

 /* Note that proc surveymeans gives the 95% confidence interval for
    the mean as [260706, 335088].  Proc surveymeans uses the t percentile
    with 299 degrees of freedom, which is 1.96793.   */

 /* To estimate population total, use 'sum' in options; 'clsum' gives a CI for the sum. */
 /* The 'class' statement treats a variable as a categorical variable */

proc surveymeans data=agsrs total=3078 sum clsum mean clm;
   class lt200k; 
   weight sampwt;
   var acres92 lt200k;
run;

 /* ALWAYS use a weight statement in proc surveymeans.  If you omit it, SAS
    assumes that all weights are 1.  For an SRS, the estimated mean will be
    correct, but estimated totals will be wrong. */
