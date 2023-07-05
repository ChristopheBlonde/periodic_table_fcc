#!/bin/bash

# Variable to connect postgres
PSQL="psql -U freecodecamp -d periodic_table -A -t -c"

# rebuild database
psql -q -U postgres < ./periodic_table.sql

# test display tables
DISPLAY_TABLES(){
echo -e "\nDisplay properties"
echo -e "\n$($PSQL "\\d properties")"
echo -e "\nDisplay elements"
echo -e "\n$($PSQL "\\d elements")"
}

# rename column weight to atomic_mass
COMMAND_RESULT=$($PSQL "ALTER TABLE properties RENAME weight TO atomic_mass;")
if [[ $COMMAND_RESULT == 'ALTER TABLE' ]]
then
COMMAND_RESULT="" 
echo "Rename weight column done."
fi

# rename column melting_point to melting_point_celsius
COMMAND_RESULT=$($PSQL "ALTER TABLE properties RENAME melting_point TO melting_point_celsius;")
if [[ $COMMAND_RESULT == 'ALTER TABLE' ]]
then
COMMAND_RESULT="" 
echo "Rename melting_point column done."
fi
# rename column boiling_point to boiling_point_celsius
COMMAND_RESULT=$($PSQL "ALTER TABLE properties RENAME boiling_point TO boiling_point_celsius;")
if [[ $COMMAND_RESULT == 'ALTER TABLE' ]]
then
COMMAND_RESULT="" 
echo "Rename boiling_point column done."
fi
# add NOT NULL to melting_point_celsius
COMMAND_RESULT=$($PSQL "ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL;")
if [[ $COMMAND_RESULT == 'ALTER TABLE' ]]
then
COMMAND_RESULT="" 
echo "Add NOT NULL to melting_point_celsius column done."
fi
# add NOT NULL to boiling_point_celsius
COMMAND_RESULT=$($PSQL "ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL;")
if [[ $COMMAND_RESULT == 'ALTER TABLE' ]]
then
COMMAND_RESULT="" 
echo "Add NOT NULL to boiling_point_celsius column done."
fi
# add UNIQUE to symbol
COMMAND_RESULT=$($PSQL "ALTER TABLE elements ADD UNIQUE(symbol);")
if [[ $COMMAND_RESULT == 'ALTER TABLE' ]]
then
COMMAND_RESULT="" 
echo "Add UNIQUE to symbol column done."
fi
# add UNIQUE to name
COMMAND_RESULT=$($PSQL "ALTER TABLE elements ADD UNIQUE(name);")
if [[ $COMMAND_RESULT == 'ALTER TABLE' ]]
then
COMMAND_RESULT="" 
echo "Add UNIQUE to name column done."
fi
# add NOT NULL to symbol
COMMAND_RESULT=$($PSQL "ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL;")
if [[ $COMMAND_RESULT == 'ALTER TABLE' ]]
then
COMMAND_RESULT="" 
echo "Add NOT NULL to symbol column done."
fi
# add NOT NULL to name
COMMAND_RESULT=$($PSQL "ALTER TABLE elements ALTER COLUMN name SET NOT NULL;")
if [[ $COMMAND_RESULT == 'ALTER TABLE' ]]
then
COMMAND_RESULT="" 
echo "Add NOT NULL to name column done."
fi
# add FOREIGN KEY to properties(atomic_number)
COMMAND_RESULT=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY(atomic_number) REFERENCES elements(atomic_number);")
if [[ $COMMAND_RESULT == 'ALTER TABLE' ]]
then
COMMAND_RESULT="" 
echo "Add FOREIGN KEY properties(atomic_number) done."
fi
# create types table with type_id SERIAL PRIMARY KEY, type VARCHAR(30) NOT NULL
COMMAND_RESULT=$($PSQL "CREATE TABLE types(type_id SERIAL PRIMARY KEY,type VARCHAR(30) NOT NULL);")
if [[ $COMMAND_RESULT == 'CREATE TABLE' ]]
then
COMMAND_RESULT="" 
echo "Create table types done."
fi
# insert row in to types metal metalloid nonmetal
COMMAND_RESULT=$($PSQL "INSERT INTO types(type) VALUES('metal'),('metalloid'),('nonmetal')")
if [[ $COMMAND_RESULT == 'INSERT 0 3' ]]
then
COMMAND_RESULT="" 
echo "Insert row types done."
fi
# add column type_id to properties
COMMAND_RESULT=$($PSQL "ALTER TABLE properties ADD COLUMN type_id INT;")
if [[ $COMMAND_RESULT == 'ALTER TABLE' ]]
then
COMMAND_RESULT="" 
echo "Add type_id to properties done."
fi
# insert rigth type_id
COMMAND_RESULT=$($PSQL "UPDATE properties AS p SET type_id = c.type_id FROM(VALUES('metal',1),('metalloid',2),('nonmetal',3)) AS c(type,type_id) WHERE c.type = p.type ;")
if [[ $COMMAND_RESULT == 'UPDATE 9' ]]
then
COMMAND_RESULT="" 
echo "Insert rigth type_id done."
fi
# add NOT NULL properties(type_id)
COMMAND_RESULT=$($PSQL "ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL")
if [[ $COMMAND_RESULT == 'ALTER TABLE' ]]
then
COMMAND_RESULT="" 
echo "Add NOT NULL to type_id properties done."
fi
# add FOREIGN KEY properties(type_id)
COMMAND_RESULT=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY(type_id) REFERENCES types(type_id)")
if [[ $COMMAND_RESULT == 'ALTER TABLE' ]]
then
COMMAND_RESULT="" 
echo "Add FOREIGN KEY to type_id properties done."
fi
# capitalize first letter symbol
echo "$($PSQL "SELECT symbol FROM elements")" | while read SYMBOL
do
COMMAND_RESULT=$($PSQL "UPDATE elements SET symbol='$(echo $SYMBOL | sed -r 's/.*/\u&/')' WHERE symbol='$SYMBOL'")
if [[ $COMMAND_RESULT == 'UPDATE 1' ]]
then
COMMAND_RESULT=""
echo "$SYMBOL capitalize done."
fi
done
# remove zero after decimal
COMMAND_RESULT=$($PSQL "ALTER TABLE properties ALTER COLUMN atomic_mass TYPE NUMERIC;")
if [[ $COMMAND_RESULT == 'ALTER TABLE' ]]
then
COMMAND_RESULT=""
echo "Fix TYPE properties(atomic_mass) done."
fi
echo "$($PSQL "SELECT atomic_mass FROM properties")" | while read ATOMIC_MASS
do
COMMAND_RESULT=$($PSQL "UPDATE properties SET atomic_mass=$(echo $ATOMIC_MASS | sed -r 's/\.*0*$//') WHERE atomic_mass=$ATOMIC_MASS")
if [[ $COMMAND_RESULT == 'UPDATE 1' ]]
then
echo "Update atomic_mass to $(echo $ATOMIC_MASS | sed -r 's/\.*0*$//')"
fi
done
# insert elements row
COMMAND_RESULT=$($PSQL "INSERT INTO elements(atomic_number,symbol,name) VALUES(9,'F','Fluorine'),(10,'Ne','Neon')")
if [[ $COMMAND_RESULT == 'INSERT 0 2' ]]
then
COMMAND_RESULT="" 
echo "Insert row elements done."
fi
# insert properties row
COMMAND_RESULT=$($PSQL "INSERT INTO properties(atomic_number,type,atomic_mass,melting_point_celsius,boiling_point_celsius,type_id) VALUES(9,'nonmetal',18.998,-220,-188.1,3),(10,'nonmetal',20.18,-248.6,-246.1,3)")
if [[ $COMMAND_RESULT == 'INSERT 0 2' ]]
then
COMMAND_RESULT="" 
echo "Insert row properties done."
fi
# delete properties(type)
COMMAND_RESULT=$($PSQL "ALTER TABLE properties DROP COLUMN type")
if [[ $COMMAND_RESULT == 'ALTER TABLE' ]]
then
COMMAND_RESULT="" 
echo "Delete properties(type) done."
fi
# delete row properties
COMMAND_RESULT=$($PSQL "DELETE FROM properties WHERE atomic_number=1000")
if [[ $COMMAND_RESULT == 'DELETE 1' ]]
then
COMMAND_RESULT="" 
echo "Delete row properties done."
fi
# delete row elements
COMMAND_RESULT=$($PSQL "DELETE FROM elements WHERE atomic_number=1000")
if [[ $COMMAND_RESULT == 'DELETE 1' ]]
then
COMMAND_RESULT="" 
echo "Delete row element done."
fi