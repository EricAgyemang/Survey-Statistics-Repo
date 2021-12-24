/* Reads the ncvs2000 data in Sampling: Design and Analysis, 2nd ed. by Sharon L. Lohr
   Copyright 2009 by Sharon L. Lohr */

filename ncvs 'C:\ncvs2000.csv';

data ncvs;
   infile  ncvs delimiter = "," firstobs=2;
   input age married sex race hispanic hhinc away employ numinc
       violent injury medtreat medexp robbery assault 
        pweight pstrat ppsu; 
run;
