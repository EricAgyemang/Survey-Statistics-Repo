/* For use with
   Sampling: Design and Analysis, 2nd ed., by Sharon L. Lohr. Copyright 2009, Sharon L. Lohr   */

options ovp nocenter nodate;

filename cherries 'C:\Documents and Settings\Sharon Lohr\My Documents\samprev\webdata\cherry.csv';

data cherry;
  infile cherries delimiter=',' firstobs=2;
  input diam height vol;
  sampwt = 2967/31;
  obsnum = _n_;
  label diam      = 'diam (in) at 4.5 feet'
        height    = 'height of tree (feet)'
        vol       = 'volume of tree (cubic feet)'
        sampwt    = 'sampling weight'
;
 /* Plot and print the data set */

proc print data = cherry;
   var diam height vol sampwt;
