#!/bin/bash
for entry in $(cat config.txt); do
	filename=$(echo $entry | cut -d ':' -f 1)
	destdir=$(echo $entry | cut -d ':' -f 2)

	destdirexpanded=${destdir/#\~/$HOME}
	src=$(pwd)/$filename
	dest=$destdirexpanded/$filename

	if [[ ! -d $destdir ]]; then 
		mkdir -p $destdir
	fi

	while true; do
		read -p "Install $filename to $destdir? [Y/n] " yn
		case $yn in
			[Yy]*)
				ln -sni $src $dest
				break
				;;
			[Nn]*)
				break
				;;
			*)
				ln -sni $src $dest
				break
				;;
		esac
	done
done
