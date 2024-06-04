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
	
	echo srcdir: $srcdir
	echo srcname: $srcname

	fullsrc=$(pwd)/$srcdir/$srcname
	dest=$destdir/$srcdir

	echo src: $fullsrc
	echo dest: $dest
done
