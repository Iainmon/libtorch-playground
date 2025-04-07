#!/bin/sh


cd /Users/iainmoncrief/Documents/Github/libtorch-playground
rm -rf build
mkdir -p build
cd build
cmake ..
cmake --build . --parallel 4 --target install;

make -j5

./MyLibTestXX || echo 1
./TorchBridgeCHPL || echo 1

cd ..

