#!/bin/bash


cd /Users/iainmoncrief/Documents/Github/libtorch-playground;
rm -rf build;
mkdir -p build;
cd build;
cmake ..;
cmake --build . --target install;
make -j4;

