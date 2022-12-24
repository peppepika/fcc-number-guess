#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\n~~ Number Guessing Game ~~\n"

NUMBER=$(( RANDOM % 1000 + 1 ))
echo -e 'Enter your username:'
read NAME

#check if username is already present
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$NAME'")
if [[ -z $USER_ID ]] #true for new user
then
  $PSQL "INSERT INTO users(username) VALUES('$NAME')"
  echo "Welcome, $NAME! It looks like this is your first time here."
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$NAME'")
else
  N_OF_GAMES=$($PSQL "SELECT COUNT(game_id) FROM games WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT n_guesses FROM games ORDER BY n_guesses LIMIT 1")
  echo "Welcome back, $NAME! You have played $N_OF_GAMES games, and your best game took $BEST_GAME guesses."
fi

echo "Guess the secret number between 1 and 1000:"
NUMBER_OF_GUESS=1
echo $NUMBER #testing
read GUESS
# correct guess
if [[ $GUESS == $NUMBER ]]
then
  $PSQL "INSERT INTO games(user_id, n_guesses) VALUES($USER_ID, $NUMBER_OF_GUESS)"
  echo "You guessed it in $NUMBER_OF_GUESS tries. The secret number was $NUMBER. Nice job!"
fi
