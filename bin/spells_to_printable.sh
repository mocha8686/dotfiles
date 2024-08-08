#!/bin/bash

file=$1

sed -i 's/\(###\|___\|---\|\*\*Classes:\*\*.[a-zA-Z, ]\+\)//g' "$file"
sed -i 's/\*\*\*At Higher Levels.\*\*\*/\n\n\0/g' "$file"
pandoc "$file" -o "${file%.*}.html"
