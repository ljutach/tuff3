#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"
output_prefix="CompQuestion"

# Reset the counter for output files
counter=0

# Read the input file line by line
while IFS= read -r line; do
    # Check if the line starts with "###"
    if [[ $line == "###"* ]]; then
        # docker run --rm -v $(pwd):/work sparqling/sparql-formatter q1.tx
        # Create a new output file with the incremented counter
        counter=$((counter + 1))
        output_file="${output_prefix}_${counter}.sparql"
        # echo "prefix t3: <http://www.semanticweb.org/ljutach/ontologies/2023/8/tuff3#>" > "$output_file"
    fi
    if [ $counter -ne 0 ]; then
      # Append the current line to the output file
      echo "$line" >> "$output_file"
    fi
done < "$input_file"

echo "Splitting complete. ${counter} files created with prefix ${output_prefix}_"

for file in "${output_prefix}"*; do
    ls "$file"
    # Check if the file is a regular file
    if [ -f "$file" ]; then
        # Run the script for each file
        docker run --rm -v $(pwd):/work sparqling/sparql-formatter "$file" > Form"$file"
        ../formattedHTML.sh Form"$file" > "$file".html
    fi
done

