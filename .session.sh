#!/bin/bash

dir=

if [ -z ${IGNORE_SESSION+x} ]; then return; fi

if [[ -n "$dir" ]] && [[ ! -d "$dir" ]]; then
	mkdir "$dir"
fi
cd "$dir" || return
