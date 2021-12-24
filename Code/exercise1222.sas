 /* Does ranked set sampling from the file agpop.csv for Exercise 12.22 of
    Sampling: Design and Analysis, 2nd ed. by Sharon L. Lohr
    Copyright 2009 Sharon Lohr */

filename agpop 'C:\agpop.csv';
options ls=78 nodate;

data agpop;
   infile agpop delimiter= ',' firstobs = 2;
   input county $ state $ acres92 acres87 acres82 farms92
                          farms87 farms82 largef92 largef87
                          largef82 smallf92 smallf87 smallf82;
   if acres92 = -99 then acres92=.;
   if acres87 = -99 then acres87 = 0;
   /* We'll recode missing values for acres87 to 0; if it's missing, we rank that unit as the smallest */

   /* To avoid writing a macro, I select m(k^2) units and then
      assing them randomly to different samples */
   /* Let m=10 and k=4 */

proc surveyselect data=agpop method=srs n=160 out = srsag seed = 15822 stats;
   
data sampleid; /* create data set with group and sample numbers */
   do m = 1 to 10;
      do j = 1 to 4;
	     do i = 1 to 4;
	     output;
		 end;
	  end;
    end;

data srsagrss;
    merge sampleid srsag;

proc print data=srsagrss;
    var m j i acres87 acres92;
run;

 /* Sort each sample of size 4 by the x variable, acres87 */

proc sort data=srsagrss;
    by m j ; 

 /* Now find the ranks of the x variable, acres87, for each sample of size 4*/

proc rank data= srsagrss out = agrssrank;
    by m j;
	var acres87;
	ranks xrank;
run;

proc print data=agrssrank;
    var m j i acres87 xrank acres92;
run;

 /* For the ranked set sample, keep only the observations for which j=xrank */

data agrssrank;
    set agrssrank;
	if j = xrank;
run;

proc print data=agrssrank;
   var m j i acres87 xrank acres92;
run;

/* Estimate the mean and variance of y, using the ranked set sample */

proc means data=agrssrank noprint;
   by m;
   var acres92;
   output out=rssout mean = ymean;
run;

proc print data=rssout;
run;

proc means data=rssout mean stderr clm;
   var ymean;
run;
