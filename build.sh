#!/bin/bash
ROOT=`pwd`

ABBOT_VERSION=2855
SWINGLIBRARY_VERSION=1.5.2

OLD_LIBRARY=swinglibrary-${SWINGLIBRARY_VERSION}.jar
NEW_LIBRARY_NAME=swinglibrary-${SWINGLIBRARY_VERSION}a
NEW_LIBRARY_DIR=$ROOT/$NEW_LIBRARY_NAME

# unpack and abbot and re-locate under org/robotframework before build
# Check-out version of abbot known to work - assume that if abbot dir exists
# already that it is the right one; delete by hand to force re-checkout
if [ ! -d "abbot" ]; then
    svn co -r $ABBOT_VERSION https://abbot.svn.sourceforge.net/svnroot/abbot/abbot/trunk/ abbot
fi

# Check-out the version of swinglibrary we want to work with
# assume jar is OK if already present
if [ ! -f "swinglibrary=${SWINGLIBRARY_VERSION}.jar" ]; then
    wget https://robotframework-swinglibrary.googlecode.com/files/swinglibrary-${SWINGLIBRARY_VERSION}.jar
fi

cd $ROOT/abbot/src
mkdir -p org/robotframework
mv abbot org/robotframework
find . -name "*.java" -exec sed -i -f ../../fix.sed {} \;

cd $ROOT/abbot/test
mkdir -p org/robotframework
mv abbot org/robotframework
find . -name "*.java" -exec sed -i -f ../../fix.sed {} \;

cd $ROOT/abbot/ext
mkdir -p org/robotframework
mv abbot org/robotframework
find . -name "*.java" -exec sed -i -f ../../fix.sed {} \;

cd $ROOT/abbot
find . -name Strings.java -exec sed -i -e "s/CORE_BUNDLE = \"org\.robotframework\./CORE_BUNDLE = \"/" {} \;

cd $ROOT
cp build.xml abbot/

#############################

# compile

cd $ROOT/abbot
rm -Rf build
ant
cd build/classes
cp -R abbot/* org/robotframework/abbot/
rm -Rf abbot

# extract original swinglibrary, splice in new abbot
cd $ROOT
rm -Rf $NEW_LIBRARY_DIR
mkdir $NEW_LIBRARY_DIR
cd $NEW_LIBRARY_DIR
jar xf ${ROOT}/${OLD_LIBRARY}

cd $NEW_LIBRARY_DIR/org/robotframework
rm -Rf abbot
cp -R $ROOT/abbot/build/classes/org/robotframework/abbot .

cd $ROOT
rm -f ${NEW_LIBRARY_NAME}.jar
cd $NEW_LIBRARY_DIR
jar cvf ../${NEW_LIBRARY_NAME}.jar .

cd $ROOT
echo DONE
