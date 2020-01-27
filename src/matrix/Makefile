include ./makefile

LINKLIBS:=-lgfortran $(LINKLIBS)

CXX:=g++
CXXFLAGS:=-Wall -O3 -std=c++11
SHARED_FLAGS:=-shared -fPIC
PYBIND_FLAGS:=$(shell python -m pybind11 --includes)

$(TARGET): $(PROCESS) auto_dsig.o $(LIBS) $(SOURCES)
	$(CXX) -DMNAME=$(MNAME) -DFNAME=$(FNAME) $(CXXFLAGS) $(SHARED_FLAGS) -o $(TARGET) $(PYBIND_FLAGS) $(PROCESS) $(LINKLIBS) $(LDFLAGS) $(BIASDEPENDENCIES) $(SOURCES)
