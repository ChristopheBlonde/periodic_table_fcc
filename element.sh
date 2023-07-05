#!/bin/bash

PSQL="psql -U freecodecamp -d periodic_table -t -c"
INDEX=0
COUNT=$($PSQL "SELECT COUNT(*) FROM elements")

if [[ -z $1 ]]
then
echo "Please provide an element as an argument."
else
ELEMENT=$1
# get elements table
echo "$($PSQL "SELECT * FROM elements")" | while read ELEMENT_ID BAR SYMBOL BAR NAME
do
INDEX=$(($INDEX+1))
if [[ $ELEMENT_ID == $ELEMENT || $SYMBOL == $ELEMENT || $NAME == $ELEMENT ]]
then
COMMAND_RESULT=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius  FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$ELEMENT_ID")
echo "$COMMAND_RESULT" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING BAR BOILING 
do
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
done
break
fi
if (($INDEX == $COUNT))
then
echo "I could not find that element in the database."
fi
done
fi
