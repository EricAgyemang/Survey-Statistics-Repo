/* Reads data produced by the SURVEY program, for Sampling: Design and Analysis, 2nd ed. by Sharon L. Lohr
   Copyright 2009 by Sharon L. Lohr */

filename myoutput 'C:\out.txt';
options ls=78 nodate nocenter;

data tv;
   infile myoutput firstobs=2;
   input dist house value over12 under12 numtv cable hourstv news sports child movies;

/* Note that because the last line of out.txt is a character string, SAS skips
   it and gives an error in the log file. If you prefer not to have this error,
   you may remove the last line from out.txt before running SAS */
   
proc print data=tv;
run;


