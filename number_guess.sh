#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=users --tuples-only -c"

# Generate a random number between 1 and 1000
random_number=$(($RANDOM % 1000 + 1))
GAME=0

echo Enter your username:
read USER_NAME
USER_EXISTS=$($PSQL "SELECT * FROM users WHERE username='$USER_NAME'")
if [[ -z $USER_EXISTS ]]
  then
  #if there's not a entry with that name
  echo "Welcome, $USER_NAME! It looks like this is your first time here."
  INSERT_USER=$($PSQL "INSERT INTO users(games_played, best_game, username) VALUES(0, 1000,'$USER_NAME')")
  else
  #if there's a entry with that name
  #echo "$USER_EXISTS"
  echo "$USER_EXISTS" | while read USER_ID BAR GAMES_PLAYED BAR BEST_GAME BAR USERNAME
  do
  echo "Welcome back, $USER_NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi

##echo $random_number
NUMBER_OF_GUESSES=1
echo Guess the secret number between 1 and 1000:

GUESS_THE_NUMBER() {

read GUESS

if [[ $GUESS =~ ^[0-9]+$ ]]
then 
    if [[ $GUESS -lt $random_number ]]
    then
    echo "It's higher than that, guess again:"
    NUMBER_OF_GUESSES=$(expr $NUMBER_OF_GUESSES + 1)
    GUESS_THE_NUMBER
    elif [[ $GUESS -gt $random_number ]]
    then
    echo "It's lower than that, guess again:"
    NUMBER_OF_GUESSES=$(expr $NUMBER_OF_GUESSES + 1)
    GUESS_THE_NUMBER
    else
    echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $random_number. Nice job!"
    GAME=$(expr $GAME + 1)
    UPDATE_AMOUNT_OF_GAMES=$($PSQL "UPDATE users SET games_played=games_played+1 WHERE username='$USER_NAME'")
    CHECK_BEST_RESULT=$($PSQL "SELECT best_game FROM users WHERE username='$USER_NAME'")
      if [[ -z $CHECK_BEST_RESULT ]]
        then
        SAVE_BEST_RESULT=$($PSQL "UPDATE users SET best_game=$NUMBER_OF_GUESSES WHERE username='$USER_NAME'")
      elif [[ $NUMBER_OF_GUESSES -lt $CHECK_BEST_RESULT ]]
        then
        SAVE_BEST_RESULT=$($PSQL "UPDATE users SET best_game=$NUMBER_OF_GUESSES WHERE username='$USER_NAME'")
      fi
    fi
else
  echo "That is not an integer, guess again:"
  GUESS_THE_NUMBER
fi
}

if [[ $GAME -eq 0 ]]
then
GUESS_THE_NUMBER
fi











