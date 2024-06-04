#!/bin/bash
for entry in $(cat config.txt); do
	filename=$(echo $entry | cut -d ':' -f 1)
	destdir=$(echo $entry | cut -d ':' -f 2)

	src=$(pwd)/$filename
	dest=${destdir/#\~/$HOME}/$filename

	ln -sni $src $dest
done
