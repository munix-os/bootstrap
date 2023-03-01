#!/usr/bin/env bash

BUILD_DIR="$1"
[ "x$BUILD_DIR" = "x" ] && BUILD_DIR="build"

files="$(find $BUILD_DIR/tools/ -maxdepth 1 -name *.tar.gz)"
filedir="$(mktemp -d)"
filelist=($files)

for file in "${filelist[@]}"; do
	echo "uploading tool $(basename $file .tar.gz)"
	cp $file $filedir
done

scp $filedir/* sigterm@mkall.org:/home/sigterm/.www/tools/
