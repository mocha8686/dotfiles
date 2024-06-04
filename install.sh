#!/bin/bash
for entry in $(cat config.txt); do
	fullsrc=$(echo $entry | cut -d ':' -f 1)
	fulldest=$(echo $entry | cut -d ':' -f 2)

	destdir=${fulldest/#\~/$HOME}
	case $fullsrc in
		*/*)
			srcdir=$(echo $fullsrc | rev | cut -d '/' -f 2- | rev)
			;;
		*)
			srcdir=.
			;;
	esac
	srcname=$(echo $fullsrc | rev | cut -d '/' -f 1 | rev)

	src=$(pwd)/$srcdir/$srcname
	dest=$destdir

	while true; do
		if [[ ! -d $destdir ]]; then 
			mkdir -p $destdir
		fi

		if [[ -f $destdir/$srcname ]]; then
			break
		fi

		read -p "Install $srcname to $destdir? [Y/n] " yn
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
