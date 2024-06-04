#!/bin/bash
while read -r entry; do
	fullsrc=$(echo "$entry" | cut -d ':' -f 1)
	fulldest=$(echo "$entry" | cut -d ':' -f 2)

	destdir=${fulldest/#\~/$HOME}
	case $fullsrc in
		*/*)
			srcdir=$(echo "$fullsrc" | rev | cut -d '/' -f 2- | rev)
			;;
		*)
			srcdir=.
			;;
	esac
	srcname=$(echo "$fullsrc" | rev | cut -d '/' -f 1 | rev)

	src=$(pwd)/$srcdir/$srcname
	dest=$destdir

	if [[ ! -d $destdir ]]; then 
		mkdir -p "$destdir"
	fi

	if [[ -f $destdir/$srcname ]]; then
		continue
	fi

	read -rp "Install $srcname to $destdir? [Y/n] " yn
	case $yn in
		[Nn]*) continue;;
		*)
			if [[ -L "$src" ]] && [[ -e "$src" ]]; then
				read -rp "Replace $destdir? [y/N] " yn
				case $yn in
					[Yy]*) ;;
					*) continue;;
				esac
			fi
			ln -snf "$src" "$dest"
			;;
	esac
done < config.txt
