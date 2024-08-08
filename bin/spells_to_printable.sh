#!/bin/bash

file=$1

sed -i 's/\(###\|___\|---\|\*\*Classes:\*\*.[a-zA-Z, ]\+\)//g' "$file"
pandoc "$file" -o "${file%.*}.html"
