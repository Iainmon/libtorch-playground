#!/bin/sh


cd /Users/iainmoncrief/Documents/Github/libtorch-playground
rm -rf build
mkdir -p build
cd build
cmake ..

cmake --build . --parallel 5 --target install;
make -j5

./MyLibTestXX > /dev/null || echo 1

echo "Running TorchBridgeCHPL"

./TorchBridgeCHPL && echo "Success!"

cd ..

