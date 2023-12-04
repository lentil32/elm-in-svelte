#!/bin/sh

project_root=$(pwd)
elm_root=$project_root/src/lib/elm

build_example1() {
	cd $elm_root/examples1
	elm make src/* --output=$project_root/static/elm/elm.js --optimize
}

build_example2() {
	cd $elm_root/examples2

	for elm_file in src/*.elm; do
		base_name=$(basename "$elm_file" .elm)
		js_out_path="${project_root}/static/elm/${base_name}.js"
		elm make "$elm_file" --output="$js_out_path" --optimize
	done
}

if [ "$1" = "1" ]; then
	build_example1
elif [ "$1" = "2" ]; then
	build_example2
fi
