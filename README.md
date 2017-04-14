Gov-Tuner
------
Fine tune your CPU governor for perfect balance between battery life and performance.

Visit [the official thread in XDA](http://forum.xda-developers.com/android/software-hacking/mod-gov-tuner-project-29th-june-2016-t3407828) for support and governor requests!

##### Compatible Governors :
- Interactive
- Conservative
- Yankactive
- Intelliactive
- Bioshock
- Lionfish
- Impulse
- Uberdemand
- Electroactive
- IntelliMM
- Barry_Allen
- BluActive
- DanceDance
- Lionheart
- PegasusQ
- Ondemand
- Smartmax
- Optimax
- ConservativeX
- Interactive_pro
- Wheatley
- Ondemandplus
- Smartmax_eps
- Intellidemand
- Tripndroid
- ... And more to come !

## Building Gov-Tuner
Gov-Tuner provides necessary buildscript to compile together a working flashable zip and an uninstaller zip. The script should work with Windows, Mac, and general Linux distributions. Both Mac and Linux needs to install "zip" first since Gov-Tuner does not supply the prebuilt binary.

To build, make sure you're in the Gov-Tuner source folder. Type the following command to build:

##### Linux and Mac

	./build.sh VERSION

##### Windows

	build VERSION

Where VERSION is the version intended to be built.

The output file location will be shown once the build is complete.