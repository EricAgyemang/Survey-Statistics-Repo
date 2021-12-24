/* Reads the baseball data from Sampling, Design and Analysis, 2nd ed. by Sharon L. Lohr
   Copyright 2009 by Sharon L. Lohr */

filename baseball 'c:\baseball.csv';


/* Variable codes
1	   team    	   team played for at beginning of the season  
2	   leagueID    	   AL or NL    
3	   player  a unique identifier for each baseball player    
4	   salary  player salary in 2004   
5	   POS 	   primary position coded as P, C, 1B, 2B, 3B, SS, RF, LF, or CF   
6	   G   	   games played    
7	   GS  	   games started   
8	   InnOuts number of innings   
9	   PO  	   Put Outs    
10	   A   	   number of assists   
11	   E   	   Errors  
12	   DP  	   number of double plays  
13	   PB  	   number of passed balls (only applies to catchers)   
14	   GB   	   number of games that player appeared at bat 
15	   AB  	   number of at bats   
16	   R   	   number of runs scored   
17	   H   	   number of hits  
18	   SecB    number of doubles   
19	   ThiB    number of triples   
20	   HR  	   number of home runs 
21	   RBI 	   number of runs batted in    
22	   SB  	   number of stolen bases  
23	   CS  	   number of times caught stealing 
24	   BB  	   number of times walked  
25	   SO  	   number of strikeouts    
26	   IBB 	   number of times intentionally walked    
27	   HBP 	   number of times hit by pitch    
28	   SH  	   number of sacrifice hits    
29	   SF  	   number of sacrifice flies   
30	   GIDP    grounded into double play   
*/
data baseball; 
infile baseball delimiter=',';
input team $ leagueID $ player $ salary POS $ G GS InnOuts PO A E DP PB
    GB AB R H SecB ThiB HR RBI SB CS BB SO IBB HBP SH SF GIDP;
logsal = log(salary);
run;

proc print data = baseball (obs=10);

run;

