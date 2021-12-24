/* This SAS code calculates the results from Example 4.8 in
   Sampling: Design and Analysis, 2nd ed. by S. Lohr
   Copyright 2008 by S. Lohr*/

options nocenter ls=78;

/* domain 1 is large open motorboats, domain 2 is all other boats */
data boats;
   input boatsize children frequen;
   sampwt = 266.6666667;
   datalines;
1 0 76
1 1 139
1 2 166
1 3 63
1 4 19
1 5 5
1 6 3
1 8 1
2 0 528 /* There are 1028 observations in domain 2, small boats */
2 1 189
2 2 225
2 3 76
2 4 8
2 5 2
;

/* Expand the data so there are 1500 observations, each representing 1 respondent */
data boats2;
   set boats;
   do i = 1 to frequen;
      if children = 0 then childyes = 0;
      else if children >=1 then childyes = 1;
      output;
   end;
run;

/* proc print data=boats2; */

proc freq data = boats2; /* check that data were expanded correctly */
   tables boatsize*children;
run;

proc surveymeans data=boats2 total = 400000 mean sum clm clsum;
   var childyes children;
   weight sampwt;
   domain boatsize;
run;
