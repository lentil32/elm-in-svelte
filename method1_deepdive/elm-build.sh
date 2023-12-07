#!/bin/sh

project_root=$(pwd)
elm_root=$project_root/src/lib/elm

build_then_uglify() {
	local js=$1
	local min=$2
	shift 2

	elm make --output="$js" --optimize "$@"
	uglifyjs "$js" \
		--compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' |
		uglifyjs --mangle --output "$min"
	rm $js
}

build_example1() {
	local js="$project_root/static/elm/elm.unmin.js"
	local min="$project_root/static/elm/elm.js"

	cd $elm_root/examples1
	build_then_uglify $js $min src/*
}

build_example2() {
	cd $elm_root/examples2

	for elm_file in src/*.elm; do
		base_name=$(basename "$elm_file" .elm)
		js="${project_root}/static/elm/${base_name}.unmin.js"
		min="${project_root}/static/elm/${base_name}.js"
		build_then_uglify $js $min $elm_file
	done
}

if [ "$1" = "1" ]; then
	build_example1
elif [ "$1" = "2" ]; then
	build_example2
fi
