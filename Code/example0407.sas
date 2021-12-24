/* Analyzes the data in Example 4.7 of 
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

 

 /* proc surveymeans also calculates estimates for domains, using domain stmt*/
 /* Note that we should not use a BY statement for domain estimates; the BY statement
    treats sample sizes in each BY group as fixed, when in fact they are random */

/* SAS uses the formula in (4.13) of the book to calculate the standard error;
   it also uses a t distribution with (n-1) degrees of freedom for the CI. 
   In this case, it might be better to use a t distribution with (n_d -1) = 38 df. */

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


