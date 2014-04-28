#!/bin/bash

SRC="src"
NAME="ACC"
VERSION=0.9.1

GIT=`sh ./distgit.sh $SRC`

# cleanup!
./clean.sh 2> /dev/null

# *.love
cd $SRC
zip -r ../${NAME}_${GIT}.love *
cd ..

# Temp Space
mkdir tmp

# Windows 32 bit
cat dev/build_data/love-$VERSION\-win32/love.exe ${NAME}_${GIT}.love > tmp/${NAME}_${GIT}.exe
cp dev/build_data/love-$VERSION\-win32/*.dll tmp/
cd tmp
zip -r ../${NAME}_win32[$GIT].zip *
cd ..
rm tmp/* -rf #tmp cleanup

# Windows 64 bit
cat dev/build_data/love-$VERSION\-win64/love.exe ${NAME}_${GIT}.love > tmp/${NAME}_${GIT}.exe
cp dev/build_data/love-$VERSION\-win64/*.dll tmp/
cd tmp
zip -r ../${NAME}_win64[$GIT].zip *
cd ..
rm tmp/* -rf #tmp cleanup

# OS X
cp dev/build_data/love.app tmp/${NAME}_${GIT}.app -Rv
cp ${NAME}_${GIT}.love tmp/${NAME}_${GIT}.app/Contents/Resources/
patch tmp/${NAME}_${GIT}.app/Contents/Info.plist -i dev/build_data/osx.patch
cd tmp
zip -r ../${NAME}_macosx[$GIT].zip ${NAME}_${GIT}.app
cd ..
rm tmp/* -rf #tmp cleanup

# Cleanup
rm tmp -rf
