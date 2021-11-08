-- ----------------------- ** SQL MINI PROJECT 2021 **------------------- --

use ipl;

-- 1.Show the percentage of wins of each bidder in the order of highest to lowest percentage.

select bidder_id, round((count(if(bid_status ='Won',1,Null))/count(if(bid_status != 'Cancelled',1,Null)))*100,1) as Percent_Win
from ipl_bidding_details
group by bidder_id
order by Percent_Win desc;


-- 2. Display the number of matches conducted at each stadium with stadium name, city from the database.
select st.stadium_id,st.stadium_Name,st.city,count(ms.match_id) as No_of_Completed_Matches
from ipl_stadium as st join ipl_match_schedule as ms 
on st.stadium_id = ms.stadium_id
where ms.status != 'Cancelled'
group by st.stadium_id
order by st.stadium_id;


-- 3.In a given stadium, what is the percentage of wins by a team which has won the toss?

select st.stadium_id,st.stadium_name,
round(count(if(if(m.toss_winner = 1,m.team_id1,m.team_id2)= if(m.match_winner =1,m.team_id1,m.team_id2),1,null))/count(if(m.toss_winner = 1,m.team_id1,m.team_id2)) * 100,2) as Percent_Win
from ipl_stadium as st join ipl_match_schedule as ms 
on st.stadium_id = ms.stadium_id 
join ipl_match as m on m.match_id = ms.match_id
where ms.status <> 'Cancelled'
group by st.stadium_id,st.stadium_name
order by st.stadium_id asc;

-- 4.Show the total bids along with bid team and team name.

select bd.bid_team,t.team_name,count(bd.bidder_id) as Total_No_Of_Bids
from ipl_bidding_details as bd left join ipl_team t
on bd.bid_team = t.team_id
group by bd.bid_team,t.team_name;

-- 5.Show the team id who won the match as per the win details.

select m.match_id,m.win_details,MID(m.win_details,6,3) as Win_Team,t.team_id,t.team_name
from ipl_match m left join ipl_team as t 
on if(m.match_winner= 1 ,m.team_id1,m.team_id2) = t.team_id;

-- 6. Display total matches played, total matches won and total matches lost by team along with its team name.

select ts.team_id,t.team_name,sum(ts.matches_played) as Total_Matches_Played,sum(ts.matches_won) as Total_Won,sum(ts.matches_lost)as Total_Lost
from ipl_team_standings ts join ipl_team t
on ts.team_id = t.team_id
group by ts.team_id,t.team_name;

-- 7. Display the bowlers for Mumbai Indians team.

select tp.player_id,P.Player_name,tp.Player_role,T.Team_name
from ipl_player as P join ipl_team_players as tp
on P.player_id = tp.Player_id
join ipl_team as T on T.team_id = tp.team_id
where tp.Player_role like'%Bowler%' and T.team_name = 'Mumbai Indians';


-- 8. How many all-rounders are there in each team, Display the teams with more than 4 all-rounders in descending order.

select tp.team_id,T.Team_name,count(tp.player_id) as Count_of_AllRounders
from ipl_team_players tp join ipl_team as T on T.team_id = tp.team_id
where tp.Player_role like'%All-Rounder%' 
group by tp.team_id,T.Team_name;




