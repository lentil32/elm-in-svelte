#!/bin/sh

project_root=$(pwd)
elm_root=$project_root/src/lib/elm

build_and_uglify() {
	local js=$1
	local min=$2

	elm make src/* --output=$js --optimize
	uglifyjs $js \
		--compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' |
		uglifyjs --mangle --output $min
}

build_example1() {
	local js="$project_root/static/elm/elm.js"
	local min="$project_root/static/elm/elm.min.js"

	cd $elm_root/examples1
	build_and_uglify $js $min
}

build_example2() {
	cd $elm_root/examples2

	for elm_file in src/*.elm; do
		base_name=$(basename "$elm_file" .elm)
		js="${project_root}/static/elm/${base_name}.js"
		min="${project_root}/static/elm/${base_name}.min.js"
		echo $js
		echo $min
		elm make $elm_file --output=$js --optimize
		build_and_uglify $js $min
	done
}

if [ "$1" = "1" ]; then
	build_example1
elif [ "$1" = "2" ]; then
	build_example2
fi
