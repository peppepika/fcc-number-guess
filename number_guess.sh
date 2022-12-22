#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guessing_game -t --no-align -c"

echo -e "\n~~ Number Guessing Game ~~\n"

echo Enter you username:
read NAME