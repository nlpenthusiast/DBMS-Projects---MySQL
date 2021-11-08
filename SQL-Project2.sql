# ICC Test Cricket

#Dataset : ICC Test Batting Figures.csv
#License: Public
#Source: https://www.kaggle.com

#Test cricket is the form of the sport of cricket with the longest match duration and is considered the game's highest standard. 
#Test matches are played between national representative teams that have been granted ‘Test status’,
--  as determined and conferred by the International Cricket Council (ICC). 
-- The term Test stems from the fact that the long, gruelling matches are mentally and physically testing. 
-- Two teams of 11 players each play a four-innings match, which may last up to five days (or longer in some historical cases). 
-- It is generally considered the most complete examination of a team's endurance and ability.
#The Data consists of runs scored by the batsmen from 1877 to 2019 December.

#Data Dictionary:
#1.Player - Name of the player and country the player belongs to
#2. Span - The duration of years between which the player was active 
#3. Mat - No of matches played by the player
#4. Inn - No of innings played by the player
#5.No - No of matches the player was NOT OUT by the end of the match.
#6. Runs - Total number of runs scored by the player
#7.HS - Highest Score of the player
#8.Avg - Average runs scored by the player in all the matches
#9.100 - No of centuries scored by the player
#10.50 - No of fifties scored by the player
#11.0 - No of Duck outs of the player
#12. Player Profile - Link to the profiles of the players


#Tasks to be performed:
#Import the csv file to a table in the database.
use Inclass;
select * from `icc test batting figures`;

#1. Remove the column 'Player Profile' from the table.
 Alter table `icc test batting figures` drop column `Player Profile`;
 desc `icc test batting figures`;

#2. Extract the country name and player names from the given data and store it in seperate columns for further usage.
/*ADDING 2 NEW COLUMNS INTO TABLE: */
Alter table `icc test batting figures` add column Player_Name varchar(150) not null FIRST;
Alter table `icc test batting figures` add column Country varchar(150) not null After Player_Name;
desc `icc test batting figures`;

-- alter table `icc test batting figures` modify column Player 

/*Inserting values into the newly added Playername and Country columns:
SpLitting the column PlayerName using substring_index function to obtain name and country of players */
Update `icc test batting figures` set Player_Name = substring_index(Player,'(',1);
Update `icc test batting figures` set Country = substring_index(substring_index(Player,'(',-1),')',1);

select * from `icc test batting figures`;

#3. From the column 'Span' extract the start_year and end_year and store them in seperate columns for further usage.
/* ADDING 2 NEW COLUMNS INTO TABLE :*/
Alter table `icc test batting figures` add column Start_Year varchar(5);
Alter table `icc test batting figures` add column End_Year varchar(5);
/*CHECKING THE NEW INSERTIONS: */
desc `icc test batting figures`;

/*Updating the values in the 2 new columns : */
Update `icc test batting figures` set Start_Year =  LEFT(span,4);
Update `icc test batting figures` set End_Year =  right(span,4);
select * from `icc test batting figures`;



#4. The column 'HS' has the highest score scored by the player so far in any given match.
--  The column also has details if the player had completed the match in a NOT OUT status. 
-- Extract the data and store the highest runs and the NOT OUT status in different columns.

Alter table `icc test batting figures` add column Not_OUT_status varchar(4) After HS;
Desc `icc test batting figures`;

/* Inserting values into column Not_out status: */

Update `icc test batting figures` set Not_OUT_status = case 
													   when RIGHT(HS,1) = '*' then 'YES' 
                                                       else 'NO' 
                                                       end;


/*REMOVING * FROM HIGH SCORE COLUMN: */
Update `icc test batting figures` set HS = substring_index(HS,'*',1);

SELECT * from `icc test batting figures`;

#5. Using the data given, considering the players who were active in the year of 2019, 
#create a set of batting order of best 6 players using the selection criteria of those who have a good average score across 
#all matches for India.

select Player_Name,Country,avg,Start_Year,End_Year,
dense_rank() over(order by avg desc) as Batting_Order
from `icc test batting figures`
where Start_Year <= 2019 and End_Year >=2019 and Country like '%Ind%'
limit 6; 


#6. Using the data given, considering the players who were active in the year of 2019, create a set of batting order of 
#best 6 players using the selection criteria of those who have highest number of 100s across all matches for India.

select Player_Name,Country,`100`,Start_Year,End_Year,
dense_rank() over(order by `100` desc) as Batting_Order_centuriescount
from `icc test batting figures`
where Country like '%India%'and Start_Year <= 2019 and End_Year =2019
limit 6;



#7. Using the data given, considering the players who were active in the year of 2019, create a set of batting order 
#of best 6 players using 2 selection criterias of your own for India.

#Using Runs and Inn as the criteria for batting order: 
select Player_Name,Country,Inn,Runs,Start_Year,End_Year,
dense_rank() over(order by Runs desc ,Inn desc) as Batting_Order
from `icc test batting figures`
where Country like '%India%'and Start_Year <= 2019 and End_Year =2019
limit 6;



#8. Create a View named ‘Batting_Order_GoodAvgScorers_SA’ using the data given, considering the players who were 
#active in the year of 2019, create a set of batting order of best 6 players using the selection criteria of those 
#who have a good average score across all matches for South Africa.

create view Batting_Order_GoodAvgScorers_SA as 
select Player_Name,Country,avg,Start_Year,End_Year,
dense_rank() over(order by avg desc) as Batting_Order
from `icc test batting figures`
where Start_Year <= 2019 and End_Year >=2019 and Country like '%SA%'
limit 6; 

select * from Batting_Order_GoodAvgScorers_SA ;

#9. Create a View named ‘Batting_Order_HighestCenturyScorers_SA’ Using the data given, considering the players who 
#were active in the year of 2019, create a set of batting order of best 6 players using the selection criteria of 
#those who have highest number of 100s across all matches for South Africa.


create view Batting_Order_HighestCenturyScorers_SA as
select Player_Name,Country,`100`,Start_Year,End_Year,
dense_rank() over(order by `100` desc) as Batting_Order_centuries
from `icc test batting figures`
where Country like '%SA%'and Start_Year <= 2019 and End_Year =2019
limit 6;

select * from Batting_Order_HighestCenturyScorers_SA ;