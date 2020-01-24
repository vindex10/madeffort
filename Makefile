matrix: src/matrix.cpp
	mkdir -p build/
	g++ -O3 -shared -std=c++11 -Iexternal/build/include/ -I/usr/include/python3.6m -fPIC `python3 -m pybind11 --includes` -o build/matrix`python3-config --extension-suffix` src/matrix.cpp
