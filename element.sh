#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if no arguments are provided
if [ $# -eq 0 ]; then
    echo "Please provide an element as an argument."
    exit
fi

# Function to retrieve element information
retrieve_element_info() {
    # Check if the argument is a number
    if [[ $1 =~ ^[0-9]+$ ]]; then
        #element_info=$($PSQL "SELECT * FROM properties WHERE atomic_number = $1;")
        element_info=$($PSQL "SELECT properties.*, elements.name, elements.symbol, types.type FROM properties JOIN elements  ON properties.atomic_number = elements.atomic_number JOIN types ON properties.type_id = types.type_id WHERE properties.atomic_number = $1;")
        
    else
        # Check if the argument is a symbol or name
        element_info=$($PSQL "SELECT properties.*, elements.name, elements.symbol, types.type FROM properties JOIN elements  ON properties.atomic_number = elements.atomic_number JOIN types ON properties.type_id = types.type_id WHERE elements.symbol = '$1' OR elements.name = '$1';")        
        
        
    fi

    # Check if the result is empty
    if [[ -z "$element_info" ]]; then
        echo "I could not find that element in the database."
    else
        
        
      
        IFS='|' read -r atomic_number atomic_mass melting_point boiling_point _ name symbol type <<< "$element_info"
        echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
    fi
}

# Retrieve element information based on the argument provided
retrieve_element_info "$1"
