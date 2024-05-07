#!/bin/bash

printf "\nCopying project stuff from ../lab2 to current directory\n\n"

cp -R ../../../lab3/.vscode .
cp -R ../../../lab3/cmake .
cp ../../../lab3/.gitignore .
cp ../../../lab3/CMakeLists.txt .

printf "\nDone.\n"
