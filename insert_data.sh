#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE teams,games")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOAL OPPONENT_GOAL
do
  #check for title
  if [[ $WINNER != 'winner' ]]
  then
    #Add to teams
    #get team_id
    #check if a winnig team exists
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    if [[ -z $TEAM_ID ]]
    then
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Added $WINNER to teams
      fi
    fi
    #check if opponent exists
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    if [[ -z $TEAM_ID ]]
    then
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Added $OPPONENT to teams
      fi
    fi

    #Add to games
    #get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    #Add values
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($YEAR, '$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOAL,$OPPONENT_GOAL)")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo "$($PSQL "SELECT * FROM games")"
    fi
  fi

done