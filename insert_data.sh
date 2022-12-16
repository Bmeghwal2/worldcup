#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $WINNER != "winner" ]]
then
#get_team_id
TEAM_ID=$($PSQL "select distinct(team_id) from teams where name='$WINNER'")
#echo $TEAM_ID
#if_not_found
if [[ -z $TEAM_ID ]]
then
#insert_winner_name
INSERT_WINNER_NAME_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
if [[ $INSERT_WINNER_NAME_RESULT == "INSERT 0 1" ]]
then
echo Inserted to teams, $WINNER
fi
fi
fi
if [[ $OPPONENT != "opponent" ]]
then
#get_team_id
TEAM_ID=$($PSQL "select distinct(team_id) from teams where name='$OPPONENT'")
#echo  $TEAM_ID
#if_not_found
if [[ -z $TEAM_ID ]]
then
#insert_opponent_name
INSERT_OPPONENT_NAME_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")
if [[ $INSERT_OPPONENT_NAME_RESULT == "INSERT 0 1" ]]
then
echo Inserted to teams, $OPPONENT
fi
fi
fi
#get_game_id
if [[ $YEAR != "year" ]]
then
#get_winner_id & opponent_id
WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
#if_not_found
if [[ -z $WINNER_ID || -z $OPPONENT_ID ]]
then
#set winner_id and opponent_id null
WINNER_ID=NULL
OPPONENT_ID=NULL
fi
#insert_games
INSERT_GAME_RESULT=$($PSQL "insert into games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) values($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID)")
if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
then
echo Inserted data to games, $YEAR, $ROUND, $WINNER, $OPPONENT, $WINNER_GOALS, $OPPONENT_GOAL
fi
fi
done
