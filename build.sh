#!/bin/bash
## Gov-Tuner ZIP creation
### Written by F4uzan, with the help of Gov-Tuner Team
#
# This script should build a zip archive containing all the files excluding the ".git" folder
# Works on Linux with proper "zip" installation
#
# Usage:
# ./build.sh <ARGUMENTS> <VERSION>
#
# Additional arguments:
# build: Build a regular flashable zip
# magisk : Build a Magisk-compatible zip
# install : Build a regular zip then install
# magisk-install : Build a Magisk-compatible zip then install
#
# Example:
# ./build.sh 4.0.1

version=$1
dir=$(pwd)

if [ ! -d output ]; then
	mkdir output
fi

echo "Building Gov-Tuner v$version"
echo "----------------------"

# Build and copy uninstaller before doing anything
echo "Building Uninstaller"
cd uninstaller; zip -r Uninstall_Gov-Tuner.zip .>/dev/null
echo "Moving Uninstaller to common/system/etc/GovTuner"
mv Uninstall_Gov-Tuner.zip ../common/system/etc/GovTuner
cd ..

echo "Using zip to build output"
echo "Building output zip"
zip -r output/Gov-Tuner_$version.zip . -x ".git/*" "win/*" "uninstaller/*" "build.*" ".gitignore" "Gov-Tuner_*.zip">/dev/null
echo "Output created: $dir/output/Gov-Tuner_$version.zip"
echo ""

echo "Push file to sdcard? (Y/n) : "
  read -r p
  case $p in
	y|Y)
          total=$(adb devices | grep "device" | wc -l)
          if [ "$total" -le 1 ]; then
             echo "Device not found , check adb connection"
             exit
          fi
          if [ "$total" -gt 1 ]; then
             adb push Gov-Tuner_$version.zip /sdcard/Gov-Tuner_$version.zip
             echo "File copied to sdcard"
               echo "Reboot recovery? (Y/n) : "
               read -r q
               case $q in
                  y|Y)
                     echo "Rebooting to recovery in 3 seconds , press Ctrl+C to abort"
                     sleep 4
                     adb reboot recovery
                  ;;
                  n|N)
                     echo "Carry on with the development"
                     exit
                  ;;
                  *)
	             echo "Invalid option, please try again";
	             exit
	          ;;
               esac
          fi
        ;;
        n|N)
          echo "Carry on with the development"
          exit
        ;;

        *)
	  echo "Invalid option, please try again";
	  exit
	;;
  esac
