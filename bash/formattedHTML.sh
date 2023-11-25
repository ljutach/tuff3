#!/bin/bash

# Get the input file name from the command line
input_file="$1"
echo "<html> <p>"

# Read the file line by line and count spaces at the beginning of each line
while IFS= read -r line; do
    # Use parameter expansion to remove leading spaces and get the count
    count=$(expr "$line" : '[[:space:]]*')
    echo "<span style='margin-left:"$((count*6))"px'>"$line"</span><br/>"
done < "$input_file"

echo "</p> </html>"

