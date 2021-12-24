/* Analyzes the data in Examples 4.3 and 4.7 of 
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
   sampwt = 3078/300;  /* sampling weight is same for each observation */

    /* Define domains of interest:  west and nonwest */
   if state in ('AK', 'AZ', 'CA', 'CO', 'HI', 'ID', 'MT', 'NV', 'NM',
      'OR', 'UT', 'WA', 'WY') then west = 1;
   else west=0;
   acres92w = acres92*west;
run;

   /* We want to do ratio estimation this time. Let's look
      at the correlation between acres92 and acres87 */
proc corr data = agsrs;
   var acres92 acres87;

proc gplot data = agsrs;
   plot acres92 * acres87;
run;

 /* proc surveymeans will estimate ratios with keyword 'ratio'  */

 /* Note that the estimated means and totals of acres87 and acres92
    do not use ratio estimation, however---these are calculated
    using SRS formulas */
 
proc surveymeans data=agsrs total=3078 mean stderr clm sum clsum ratio ;
   var acres92 acres87;  /* need both in var statement */
   ratio 'acres92/acres87' acres92/acres87;
   weight sampwt;
   ods output Statistics=statsout Ratio=ratioout;
   run;

/* Can get ratio estimates of totals by taking output from 
   proc surveymeans and multiplying by N */

proc print data=ratioout;
run;
data ratioout1;
   set ratioout;
   xtotal = 964470625;
   ratiosum = ratio*xtotal;
   sesum = stderr*xtotal;
   lowercls = lowercl*xtotal;
   uppercls = uppercl*xtotal;

proc print data = ratioout1;
run;

 /* proc surveymeans also calculates estimates for domains, using domain stmt*/
 /* Note that we should not use a BY statement for domain estimates; the BY statement
    treats sample sizes in each BY group as fixed, when in fact they are random */

proc surveymeans data=agsrs total = 3078 mean sum clm clsum;
   var acres92 lt200k; 
   domain west; /* Calculates means for each domain */
   weight sampwt;
run;

   /* The domain mean really is a ratio estimate; here's another way to get it*/

proc surveymeans data=agsrs total=3078 mean stderr clm ratio ;
   var acres92w west;  
   ratio 'acres92w/west'  acres92w/west; /* gives domain est for west */
   weight sampwt;
run;


