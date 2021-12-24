/* Analyzes the data in Examples 4.5 of 
   Sampling: Design and Analysis, 2nd ed. by S. Lohr 
   Copyright 2009 by Sharon Lohr */

options ls=78 nodate nocenter;
data santacruz;
   input tree seed92 seed94;
   sampwt = 1;  /* We don't know how many trees there are in the population,
            so we use relative sampling weight=1, the same for each observation */
   datalines;
1 1 0
2 0 0
3 8 1
4 2 2
5 76 10
6 60 15
7 25 3
8 2 2
9 1 1
10 31 27
;
run;

proc corr data = santacruz;
   var seed92 seed94;

proc gplot data = santacruz;
   plot seed94*seed92;
run;

 /* proc surveymeans will estimate ratios with keyword 'ratio'  */

proc surveymeans data=santacruz mean stderr clm ratio ;
   var seed94 seed92;  /* need both in var statement */
   ratio 'seed94/seed92' seed94/seed92;
   weight sampwt;
run;

