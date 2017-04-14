#!/bin/bash
## Gov-Tuner ZIP creation
### Written by F4uzan, with the help of Gov-Tuner Team
#
# This script should build a zip archive containing all the files excluding the ".git" folder
# Works on Linux with proper "zip" installation
#
# Arguments:
# ./build.sh <VERSION>
#
# Example:
# ./build.sh 4.0.1

version=$1
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

echo "Using zip to build output"
echo "Building output zip"
zip -r Gov-Tuner_$version.zip . -x ".git/*" "win/*" "uninstaller/*" "build.*" ".gitignore">/dev/null
echo "Output created: $dir/Gov-Tuner_$version.zip"
echo ""
