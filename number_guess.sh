#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\n~~ Number Guessing Game ~~\n"

NUMBER=$(( RANDOM % 1000 + 1 ))
NUMBER_OF_GUESS=0
echo -e 'Enter your username:'
read NAME

#check if username is already present
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$NAME'")
if [[ -z $USER_ID ]] #true for new user
then
  INSERT=$($PSQL "INSERT INTO users(username) VALUES('$NAME')") #adding new user to database and getting id
  echo "Welcome, $NAME! It looks like this is your first time here."
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$NAME'")
else
  N_OF_GAMES=$($PSQL "SELECT COUNT(game_id) FROM games WHERE user_id=$USER_ID") #welcoming returning player
  BEST_GAME=$($PSQL "SELECT n_guesses FROM games ORDER BY n_guesses LIMIT 1")
  echo "Welcome back, $NAME! You have played $N_OF_GAMES games, and your best game took $BEST_GAME guesses."
fi

#guess function
function GUESS() {
    NUMBER_OF_GUESS=$((NUMBER_OF_GUESS+=1))
    read GUESS
}

echo "Guess the secret number between 1 and 1000:"
echo $NUMBER #testing
GUESS

#if input is different than secret number loop starts
until [[ $GUESS -eq $NUMBER ]]
do
  if [[ $GUESS =~ ^[a-z]+$ ]] #check if input contains letters
  then
    echo 'That is not an integer, guess again:'
    NUMBER_OF_GUESS=$((NUMBER_OF_GUESS-=1))
  elif [[ $GUESS -gt $NUMBER ]] # guess and number comparison
  then
    echo "It's lower than that, guess again:"
  else
    echo "It's higher than that, guess again:"
  fi
  GUESS again  
done

INSERT1=$($PSQL "INSERT INTO games(user_id, n_guesses) VALUES($USER_ID, $NUMBER_OF_GUESS)")
echo "You guessed it in $NUMBER_OF_GUESS tries. The secret number was $NUMBER. Nice job!"
