#!/bin/bash

SCRIPTPATH=$(dirname $0)
BUILDPATH=$SCRIPTPATH/build
SKETCHNAME="rapid$1"

if [ -z "$1" ]; then
    echo "Please specify the year of the event!"
    exit 1
else
    echo "Creating the kit...."
    mkdir $BUILDPATH
    cp -r $SCRIPTPATH/src $BUILDPATH
    mv $BUILDPATH/src/src.pde $BUILDPATH/src/$SKETCHNAME.pde
    mv $BUILDPATH/src $BUILDPATH/$SKETCHNAME
    zip -r $BUILDPATH/$SKETCHNAME.zip $BUILDPATH/$SKETCHNAME
    mv $BUILDPATH/$SKETCHNAME.zip $SCRIPTPATH/
    rm -r $BUILDPATH
fi
echo "Done!"
