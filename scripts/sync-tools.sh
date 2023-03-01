#!/usr/bin/env bash

BUILD_DIR="$1"
[ "x$BUILD_DIR" == "x" ] && BUILD_DIR="build"
files="$(find $BUILD_DIR/tools/ -maxdepth 1 -name *.tar.gz)"
filelist=($files)

if [ "x$2" == "x" ]; then
	filedir="$(mktemp -d)"

	for file in "${filelist[@]}"; do
		echo "uploading tool $(basename $file .tar.gz)"
		cp $file $filedir
	done

	scp $filedir/* sigterm@mkall.org:/home/sigterm/.www/tools/
	rm -rf "$filedir"
else
	echo "uploading tool $2"
	scp $BUILD_DIR/tools/host-$2.tar.gz sigterm@mkall.org:/home/sigterm/.www/tools/
fi
