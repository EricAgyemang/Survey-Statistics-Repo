 /* This sas program constructs the empirical probability mass function
    and empirical cumulative distribution function
    in Example 7.3 of Sampling:  Design and Analysis, 2nd ed. by Sharon L. Lohr,
    using Version 9.2 of SAS.
    Copyright 2008 Sharon L. Lohr*/

filename htpop 'C:\htpop.csv'; 
filename htsrs 'C:\htsrs.csv';

options ls=78 nodate nocenter;
 
data htpop;
   infile htpop delimiter="," firstobs=2;
   input height gender;

/* Construct the empirical probability mass function and empirical cdf.*/

proc freq data=htpop;
    tables height / out = htpop_epmf outcum;
run;

/* SAS proc freq gives the values in percents, so we divide each by 100 */

data htpop_epmf;
    set htpop_epmf;
	epmf = percent/100;
	ecdf = 	cum_pct/100;
run;

/* The following gives the output in htcdf.dat. */

proc print data=htpop_epmf;
run;

data htsrs;
   infile htsrs delimiter="," firstobs=2;
   input rn height gender $;

/* Draw the histogram in Figure 7.3.  (I don't give code for Figure 7.4 because
   you want to use weights when constructing histograms for stratified samples;
   see example0706.sas. */

goptions reset=all;
goptions colors = (black);
axis4 label=(angle=90 'Percent') order=(0 to 14 by 2);
axis3 label=('Height (cm)') order =  (130 to 210 by 10);

proc univariate data=htsrs noprint;
   histogram height / midpoints = 134 to 209 by 3 haxis=axis3 vaxis=axis4;
run;

   
