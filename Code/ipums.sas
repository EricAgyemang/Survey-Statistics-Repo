/* Reads the ipums data in Sampling: Design and Analysis, 2nd ed. by Sharon L. Lohr
   Copyright 2009 by Sharon L. Lohr */

filename ipumsfl 'C:\ipums.csv';

proc format;

value ownershg
 0="N/A"
 1="Owned or being bought  (loan)"
 2="Rents"
;

value sex
 1="Male"
 2="Female"
;

value race
 1="White"
 2="Black"
 3="American Indian/Alaska Native"
 4="Asian/Pacific Islander"
 5="Other"
;

value marstat
 1="Married"
 2="Separated"
 3="Divorced"
 4="Widowed"
 5="Never married/single"
;

value hispanic
 0="Not Hispanic"
 1="Hispanic"
;

value school
 0="N/A"
 1="No, not in school"
 2="Yes, in school"
;

value educrec
 0="N/A  or No schooling"
 1="None or preschool"
 2="Grade 1, 2, 3, or 4"
 3="Grade 5, 6, 7, or 8"
 4="Grade 9"
 5="Grade 10"
 6="Grade 11"
 7="Grade 12"
 8="1 to 3 years of college"
 9="4+ years of college"
;

value labforce
 0="N/A"
 1="No, not in the labor force"
 2="Yes, in the labor force"
;

value yrsusac
 0="N/A"
 1="0-5 years"
 2="6-10 years"
 3="11-15 years"
 4="16-20 years"
 5="21+ years"
 6="Missing"
;

value classwkd
 00="N/A"
 10="Self-employed"
 11="Employer"
 12="Working on own account"
 13="Self-employed, not incorporated"
 14="Self-employed, incorporated"
 20="Works for wages"
 21="Works on salary (1920)"
 22="Wage/salary, private"
 23="Wage/salary at non-profit"
 24="Wage/salary, government"
 25="Federal govt employee"
 26="Armed forces"
 27="State govt employee"
 28="Local govt employee"
 29="Unpaid family worker"
;

value vetstat
 0="N/A"
 1="No Service"
 2="Yes"
 9="Not ascertained"
;

data ipums;
  infile ipumsfl delimiter = ',' firstobs=2;
  input geostrat psu inctot age sex race hispanic marstat ownershg yrsusa 
    school educrec labforce sei classwk vetstat ;
  if yrsusa = 6 then yrsusa=.;

label
 ownershg="Ownership of dwelling -- General"
 age="Age"
 sex="Sex"
 race="Race"
 marstat="Marital status"
 yrsusa="Years in the United States, intervalled"
 hispanic="Hispanic origin"
 school="School attendance"
 educrec="Educational attainment"
 labforce="Labor force status"
 sei="Duncan Socioeconomic Index"
 classwk="Class of worker"
 inctot="Total personal income"
 vetstat="Veteran status"
;

format
 ownershg ownershg.
 sex sex.
 race race.
 marstat marstat.
 yrsusa yrsusac.
 hispanic hispanic.
 school school.
 educrec educrec.
 labforce labforce.
 classwk classwkd.
 vetstat vetstat.
;
  run;

