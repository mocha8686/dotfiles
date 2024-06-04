#!/bin/bash
for entry in $(cat config.txt); do
	filename=$(echo $entry | cut -d ':' -f 1)
	destdir=$(echo $entry | cut -d ':' -f 2)

	destdirexpanded=${destdir/#\~/$HOME}
	src=$(pwd)/$filename
	dest=$destdir/$filename

	if [[ ! -d $destdir ]]; then 
		mkdir -p $destdir
	fi

	ln -sni $src $dest
done
