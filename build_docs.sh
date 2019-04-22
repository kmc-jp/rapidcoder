#!/bin/bash

SCRIPTPATH=$(dirname $0)
echo "Creating the kit...."
doxygen doxygen.conf
echo "Done!"
