/* Reads the VIUS data in Sampling: Design and Analysis, 2nd ed. by Sharon L. Lohr
   Copyright 2009 by Sharon L. Lohr */

filename viusdat 'C:\vius.csv';

proc format;

value trucktype
 1="pickups" 
 2="minivans, other light vans, and sport utility vehicles" 
 3="light single-unit trucks with gross vehicle weight less than  26,000 pounds" 
 4="heavy single-unit trucks with gross vehicle weight greater than or equal to 26,000 pounds" 
 5="truck-tractors"
 ;

value bodytype /* blank = truck tractor*/
01="Pickup"  
02="Minivan"  
03="Light van other than minivan " 
04="Sport utility " 
05="Armored " 
06="Beverage " 
07="Concrete mixer " 
08="Concrete pumper " 
09="Crane " 
10="Curtainside " 
11="Dump " 
12="Flatbed, stake, platform, etc=" 
13="Low boy " 
14="Pole, logging, pulpwood, or pipe " 
15="Service, utility " 
16="Service, other " 
17="Street sweeper " 
18="Tank, dry bulk " 
19="Tank, liquids or gases " 
20="Tow/Wrecker " 
21="Trash, garbage, or recycling " 
22="Vacuum " 
23="Van, basic enclosed " 
24="Van, insulated non-refrigerated " 
25="Van, insulated refrigerated " 
26="Van, open top " 
27="Van, step, walk-in, or multistop " 
28="Van, other " 
99="Other not elsewhere classified " 
;

value adm_modelyear
01="2003, 2002 " 
02="2001 " 
03="2000 " 
04="1999 " 
05="1998 " 
06="1997 " 
07="1996 " 
08="1995 " 
09="1994 " 
10="1993 " 
11="1992 " 
12="1991 " 
13="1990 " 
14="1989 " 
15="1988 " 
16="1987 " 
      17="Pre-1987"  
;

value vius_gvw
01="Less than 6,001 lbs"
02="6,001 to 8,500 lbs"
03="8,501 to 10,000 lbs"
04="10,001 to 14,000 lbs"
05="14,001 to 16,000 lbs"
06="16,001 to 19,500 lbs"
07="19,501 to 26,000 lbs"
08="26,001 to 33,000 lbs"
09="33,001 to 40,000 lbs"
10="40,001 to 50,000 lbs"
11="50,001 to 60,000 lbs"
12="60,001 to 80,000 lbs"
13="80,001 to 100,000 lbs"
14="100,001 to 130,000 lbs"
15="130,001 lbs or more"
;

value opclass
1="Private "
2="Motor carrier "
3="Owner operator "
4="Rental "
5="Personal transportation "
6="Not applicable (Vehicle not in use) "
;

value transmssn
1="Automatic "
2="Manual "
3="Semi-Automated Manual "
4="Automated Manual "
;

value trip_primary
1="Off-the-road "
2="Less than 50 miles "
3="51 to 100 miles "
4="101 to 200 miles "
5="201 to 500 miles "
6="501 miles or more "
7="Not reported "
8="Not applicable (Vehicle not in use) "
;

value adm_make
01="Chevrolet "
02="Chrysler "
03="Dodge "
04="Ford "
05="Freightliner "
06="GMC "
07="Honda "
08="International "
09="Isuzu "
10="Jeep "
11="Kenworth "
12="Mack "
13="Mazda "
14="Mitsubishi "
15="Nissan "
16="Peterbilt "
17="Plymouth "
18="Toyota "
19="Volvo "
20="White "
21="Western Star "
22="White GMC "
23="Other (domestic) "
24="Other (foreign) "
;

value business
01="For-hire transportation or warehousing "
02="Vehicle leasing or rental "
03="Agriculture, forestry, fishing, or hunting "
04="Mining "
05="Utilities "
06="Construction "
07="Manufacturing "
08="Wholesale trade "
09="Retail trade "
10="Information services "
11="Waste management, landscaping, or administrative/support services "
12="Arts, entertainment, or recreation services "
13="Accommodation or food services "
14="Other services "
;

data vius ;
   infile viusdat firstobs=2 delimiter=',';
   input STRATUM ADM_STATE STATE $ TRUCKTYPE TABTRUCKS HB_STATE $ BODYTYPE ADM_MODELYEAR 
    VIUS_GVW MILES_ANNL MILES_LIFE MPG 
    OPCLASS OPCLASS_MTR OPCLASS_OWN OPCLASS_PSL OPCLASS_PVT OPCLASS_RNT 
    TRANSMSSN TRIP_PRIMARY TRIP0_50 TRIP051_100 TRIP101_200
    TRIP201_500 TRIP500MORE ADM_MAKE BUSINESS;


label
 STRATUM="Stratum number"
 ADM_STATE="State number"
 STATE_STR="State name"
 TRUCKTYPE="Truck type: Stratum number within state"
 TABTRUCKS="Column of weights for trucks"
 HB_STATE="Home base of vehicle on July 1, 2002"
 BODYTYPE="Body type of the vehicle"
 ADM_MODELYEAR="Model year"
 VIUS_GVW="Gross vehicle weight based on average reported weight"
 MILES_ANNL="Number of Miles Driven During 2002"
 MILES_LIFE="Number of Miles Driven Since Manufactured"
 MPG="Miles Per Gallon averaged during 2002"
 OPCLASS="Operator Classification With Highest Percent"
 OPCLASS_MTR="Percent of Miles Driven as a Motor Carrier"
 OPCLASS_OWN="Percent of Miles Driven as an Owner Operator"
 OPCLASS_PSL="Percent of Miles Driven for Personal Transportation"
 OPCLASS_PVT="Percent of Miles Driven as Private (Carry Own Goods or Internal Company Business Only)"
 OPCLASS_RNT="Percent of Miles Driven as Rental"
 TRANSMSSN="Type of Transmission"
 TRIP_PRIMARY="Primary Range of Operation"
 TRIP0_50="Percent of Annual Miles Accounted for with Trips 50 Miles or Less from the Home Base"
 TRIP051_100="Percent of Annual Miles Accounted for with Trips 51 to 100 Miles from the Home Base" 
 TRIP101_200="Percent of Annual Miles Accounted for with Trips 101 to 200 Miles from the Home Base" 
 TRIP201_500="Percent of Annual Miles Accounted for with Trips 201 to 500 Miles from the Home Base" 
 TRIP500MORE="Percent of Annual Miles Accounted for with Trips 501 or More Miles from Home Base" 
 ADM_MAKE="Make of vehicle"
 BUSINESS="Business in which vehicle was most often used during 2002" 
;

format
 TRUCKTYPE trucktype.
 BODYTYPE bodytype.
 ADM_MODELYEAR adm_modelyear.
 OPCLASS opclass.
 TRANSMSSN transmssn.
 TRIP_PRIMARY trip_primary.
 ADM_MAKE adm_make.
 BUSINESS business.
;

run;
proc freq data=vius;
    tables STRATUM;
run;

