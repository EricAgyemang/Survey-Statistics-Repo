/* Analyzes Exercise 13.3 of Sampling: Design and Analysis, 2nd ed. by Sharon L. Lohr
    Copyright 2009 Sharon Lohr */

data opium;
   input elist dlist tlist count;
   datalines;
0 0 0 .
0 0 1  712
0 1 0   69
1 0 0 1728
0 1 1    8
1 0 1  314
1 1 0   27
1 1 1    6
;


proc catmod data=opium;
   weight count;
   model elist*dlist*tlist = _response_ /pred=freq ml;
   loglin elist dlist tlist;  
      /* Model of independent factors */
run;

proc catmod data=opium;
   weight count;
   model elist*dlist*tlist = _response_ /pred=freq ml;
   loglin elist dlist tlist elist*dlist;  
      /* Model with elist and dlist dependent */
run;

proc catmod data=opium;
   weight count;
   model elist*dlist*tlist = _response_ /pred=freq ml;
   loglin elist dlist tlist tlist*dlist;  
      /* Model with tlist and dlist dependent */
run;

proc catmod data=opium;
   weight count;
   model elist*dlist*tlist = _response_ /pred=freq ml;
   loglin elist dlist tlist elist*tlist;  
      /* Model with elist and tlist dependent */
run;

proc catmod data=opium;
   weight count;
   model elist*dlist*tlist = _response_ /pred=freq;
   loglin elist|dlist|tlist@2;  
      /* Model with all 2-way intrxns */
run;
