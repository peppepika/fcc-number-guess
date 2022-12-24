#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\n~~ Number Guessing Game ~~\n"

NUMBER=$(( RANDOM % 1000 + 1 ))
echo Enter you username:
read NAME

#check if username is already present
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$NAME'")
if [[ -z $USER_ID ]] #true for new user
then
  $PSQL "INSERT INTO users(username) VALUES('$NAME')"
  echo "Welcome, $NAME! It looks like this is your first time here."
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$NAME'")
else
  echo "Welcome back, $NAME! You have played <games_played> games, and your best game took <best_game> guesses."
fi

echo "Guess the secret number between 1 and 1000:"
NUMBER_OF_GUESS=0
read GUESS
#to do while loop?
if [[ $GUESS != $NUMBER ]]
then

else
  echo "You guessed it in $NUMBER_OF_GUESS tries. The secret number was $NUMBER. Nice job!"
fi