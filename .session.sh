#!/bin/bash

dir=

if [[ -n "$dir" ]] && [[ ! -d "$dir" ]]; then
	mkdir "$dir"
fi
cd "$dir" || return
