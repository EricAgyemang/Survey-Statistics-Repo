/* Analyzes the data in Examples 4.11 of 
   Sampling: Design and Analysis, 2nd ed. by S. Lohr 
   Copyright 2008 by Sharon Lohr */

filename agsrs 'C:\agsrs.csv';
options ls=78 nodate nocenter;
data agsrs;
   infile agsrs delimiter= ','  firstobs = 2;
   input county $ state $ acres92 acres87 acres82 farms92
                          farms87 farms82 largef92 largef87
                          largef82 smallf92 smallf87 smallf82;
   if acres92 < 200000 then lt200k = 1;
      else lt200k = 0; /*  counties with fewer than 200000 acres in farms */
   if acres92 = -99 then acres92 =  . ;  /* check for missing values */
   if acres92 = -99 then lt200k =  . ;
   
   if acres87 > 0 then recacr87 = 1.0/acres87;
      /* Calculate the reciprocal of x to use in the weighted least squares estimation */

run;


/* Use weighted least squares, using weights 1/x_i, to estimate parameters.
   The sampling weights w_i are not used in a model-based analysis. */

   proc reg data=agsrs;
        model acres92=acres87 / noint r p clm;
        weight recacr87;
        output out = resids residual = residual;

/* Examine residuals (used in model-based analysis) */

   data resids;
        set resids;
        if acres87 <= 0 then delete;
        wtresid = residual/sqrt(acres87);
   proc gplot data = resids;
        plot wtresid*acres87;
run;

/* Note that the SSE from the weighted least squares model is the same as
   the sum of squares of the weighted residuals. */

proc univariate data=resids;
   var wtresid; run;
