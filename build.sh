#!/bin/bash
## Gov-Tuner ZIP creation
### Written by F4uzan, with the help of Gov-Tuner Team
#
# This script should build a zip archive containing all the files excluding the ".git" folder
# Works on Linux with proper "git" and "zip" installation
#
# Arguments:
# ./build.sh <ARGUMENTS> <VERSION>
#
# Additional arguments
# -zip	: Use zip instead of git archive
#
# Example:
# ./build.sh 4.0.1

version=$2
dir=$(pwd)

echo ""
echo "Building Gov-Tuner v$2"
echo "----------------------"

# Build and copy uninstaller before doing anything
echo "Building Uninstaller"
cd uninstaller; zip -r Uninstall_Gov-Tuner.zip .>/dev/null
echo "Moving Uninstaller to common/system/etc/GovTuner"
mv Uninstall_Gov-Tuner.zip ../common/system/etc/GovTuner
cd ..

if [ $1 == "-zip" ]; then
	echo "Using zip to build output"
	echo "Building output zip"
	zip -r Gov-Tuner_$version.zip . -x ".git/*" "win/*" "uninstaller/*" "build.*" ".gitignore">/dev/null
	echo "Output created: $dir/Gov-Tuner_$version.zip"
else
	echo "Using git to build output"
	echo "Building output zip"
	git archive -o Gov-Tuner_$version.zip HEAD
	echo "Output created: $dir/Gov-Tuner_$version.zip"
fi
echo ""
