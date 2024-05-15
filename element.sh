#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

MESSAGE () {
  echo -e "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
}

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  IS_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1' LIMIT 1")
  IS_NAME=$($PSQL "SELECT name FROM elements WHERE name='$1' LIMIT 1")
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    IS_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1 LIMIT 1")
  fi

  # check if it's match an element
  if [[ -n $IS_SYMBOL || $IS_NAME || $IS_ATOMIC_NUMBER ]]
  then
    # check witch condition is true
    if [[ -n $IS_SYMBOL ]]
    then
      ATTRIBUTE="symbol"
    elif [[ -n $IS_NAME ]]
    then
      ATTRIBUTE="name"
    elif [[ -n $IS_ATOMIC_NUMBER ]]
    then
      ATTRIBUTE=atomic_number
    fi

    # fetch attribute value

    # select records

    SELECT_RECORDS=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE $ATTRIBUTE='$1' LIMIT 1")

    echo "$SELECT_RECORDS" | while IFS="|" read NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do
    MESSAGE
    done
  else
    echo -e "I could not find that element in the database."
  fi
fi
