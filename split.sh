#!/usr/bin/env bash

# Config
OUTPUT_PREFIX="output_"
OUTPUT_DIR="build"

# Arguments
if [ $# -eq 0 ]; then
    echo "Usage: $0 {file} {nb_lines}"
    echo "{file}: path to the original csv file"
    echo "{nb_lines}: count of desired lines per file (excluding headers)"
    exit 1
fi

FILE=$1
NB_LINES=$2

if [[ ! -f "$FILE" ]]; then
    echo "File not found"
    exit 1
fi

NUMBER_REGEX='^[0-9]+$'
if ! [[ $NB_LINES =~ $NUMBER_REGEX ]]; then
    echo "Size should be a number"
    exit 1
fi

echo "Start splitting..."

# Generate splitted files
mkdir -p $OUTPUT_DIR
split -l "$NB_LINES" -d "$FILE" "./$OUTPUT_DIR/$OUTPUT_PREFIX"

# Add .csv extension
OUTPUT_FILES=$(find "./$OUTPUT_DIR" -type f -name "$OUTPUT_PREFIX*")
for OUTPUT_FILE in $OUTPUT_FILES; do
    mv "$OUTPUT_FILE" "$OUTPUT_FILE.csv";
done

# Add headers
HEADERS=$(head -1 "$FILE")
OUTPUT_FILES=$(find ./$OUTPUT_DIR -type f -name "$OUTPUT_PREFIX*" -not -name "$OUTPUT_PREFIX""00.csv")
for OUTPUT_FILE in $OUTPUT_FILES; do
    echo "$HEADERS" > temp && cat "$OUTPUT_FILE" >> temp
    rm "$OUTPUT_FILE" && mv temp "$OUTPUT_FILE"
done

echo "Done."
exit 0
