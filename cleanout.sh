#!/bin/sh


cd /Users/iainmoncrief/Documents/Github/libtorch-playground
rm -rf build
mkdir -p build
cd build
cmake ..
cmake --build . --parallel 4 --target install;

make -j4

