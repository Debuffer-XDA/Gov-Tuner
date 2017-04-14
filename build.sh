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

if [ $1 == "-zip" ]; then
	zip -r Gov-Tuner_$version.zip . -x ".git/*" "win/*"
else
	git archive -o Gov-Tuner_$version.zip HEAD
fi