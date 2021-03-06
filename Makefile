LLVM_INCLUDES = -I/usr/include/llvm-3.9
PYTHON_INCUDES = -I/usr/include/python3.5

SOURCE = src/
BUILD = build/

CXX = g++

CXXFLAGS = -g -rdynamic
CXXFLAGS_LLVM = -O3 $(LLVM_INCLUDES)

LLVM_CONFIG_COMMAND = \
		`/usr/bin/llvm-config-3.9 --cxxflags --libs` \
		`/usr/bin/llvm-config-3.9 --ldflags`

PYTHON_CONFIG_COMMAND = `/usr/bin/python3.5-config --ldflags`


PROG = libStateProtectorPass.so libcheck.o
TARGETS = $(addprefix $(BUILD), $(PROG))

all: directories $(TARGETS)

.PHONY: directories
directories:
	@ mkdir -p $(BUILD)

$(BUILD)%.o: $(SOURCE)%.cpp
	$(CXX) -c -fPIC -std=c++11 $(CXXFLAGS) $(CXXFLAGS_LLVM) $(LLVM_CONFIG_COMMAND) $(PYTHON_INCUDES) $^ -o $@

$(BUILD)libStateProtectorPass.so: $(BUILD)StateProtectorPass.o
	$(CXX) $(CXXFLAGS_LLVM) $(PYTHON_INCUDES) -shared $(LLVM_CONFIG_COMMAND) $(PYTHON_CONFIG_COMMAND) $^ -o $@

.PHONY: clean
clean:
	@ rm -f $(BUILD)*.so
	@ rm -f $(BUILD)*.o
	@ rm -f $(BUILD)*.bc
