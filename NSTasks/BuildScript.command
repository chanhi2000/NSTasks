#!/bin/sh

#  BuildScript.command
#  NSTasks
#
#  Created by LeeChan on 10/11/16.
#  Copyright © 2016 MarkiiimarK. All rights reserved.


echo "*********************************"
echo "Build Started"
echo "*********************************"

echo "*********************************"
echo "Beginning Build Process"
echo "*********************************"

xcodebuild -project "${1}" -target "${2}" -sdk iphoneos -verbose CONFIGURATION_BUILD_DIR="${3}"

echo "*********************************"
echo "Creating IPA"
echo "*********************************"

/usr/bin/xcrun -verbose -sdk iphoneos PackageApplication -v "${3}/${4}.app" -o "${5}/app.ipa"
