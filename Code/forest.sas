/* Reads the forest data in Sampling: Design and Analysis, 2nd ed. by Sharon L. Lohr
   Copyright 2009 by Sharon L. Lohr */

options ovp nocenter;
filename forest 'C:\forest.csv';

data forest;
   infile forest delimiter=',';
   input elevation			
Aspect					
Slope					
Horiz
Vert
HorizRoad		
Hillshade_9am 				
Hillshade_Noon				
Hillshade_3pm				
HorizFire
Wilderness1-Wilderness4 
Cover
;	

run;
