#!/bin/bash

###########
# Configs #
###########
while read -r entry; do
	fullsrc=$(echo "$entry" | cut -d ':' -f 1)
	fulldest=$(echo "$entry" | cut -d ':' -f 2)

	destdir=${fulldest/#\~/$HOME}
	srcdir=$(dirname "$fullsrc")
	srcname=$(basename "$fullsrc")

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
done < configs.txt

#########
# Links #
#########
while read -r entry; do
	target=$(echo "$entry" | cut -d ':' -f 1)
	linkname=$(echo "$entry" | cut -d ':' -f 2)

	target=${target/#\~/$HOME}
	linkname=${linkname/#\~/$HOME}

	targetdir=$(dirname "$target")
	linknamedir=$(dirname "$linkname")

	if [[ ! -d "$targetdir" ]]; then
		mkdir -p "$targetdir"
	fi
	if [[ ! -d "$linknamedir" ]]; then
		mkdir -p "$linknamedir"
	fi

	ln -snf "$target" "$linkname"
done < links.txt
