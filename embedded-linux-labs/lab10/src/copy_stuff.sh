#!/bin/bash

printf "\nCopying project stuff from ../lab2 to current directory\n\n"

cp -R ../../lab5/.vscode .
cp -R ../../lab5/cmake .
cp ../../lab5/CMakeLists.txt .

printf "\nDone.\n"
