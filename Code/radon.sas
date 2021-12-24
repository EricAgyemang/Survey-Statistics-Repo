/* Reads the radon data in Sampling: Design and Analysis, 2nd ed. by Sharon L. Lohr
   Copyright 2009 by Sharon L. Lohr */

filename radon  'c:\radon.csv';

/* Source: http://www.epa.gov/radon/pdfs/citizensguide.pdf*/

data radon; 
   infile radon delimiter=',' firstobs=2;
   input countynum countyname $  sampsize popsize radon;
   radwt = popsize/sampsize;
   toohigh = 0;
   if radon >= 4 then toohigh = 1;
   lograd = log(radon);	/* I checked to make sure there are no 0 values */
run;
