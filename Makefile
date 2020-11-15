
PLAT = i686

C = $(PLAT)-w64-mingw32-gcc
CXX = $(PLAT)-w64-mingw32-g++
WINRES = $(PLAT)-w64-mingw32-windres

CXXFLAGS += -O2 -std=c++11 -DMODPLUG_BUILD -DMODPLUG_BASIC_SUPPORT -DMODPLUG_NO_FILESAVE -DHAVE_INTTYPES_H -DHAVE_STDINT_H -DHAVE_MALLOC_H
LDFLAGS += -s -shared -Wl,--subsystem,windows -static-libgcc -static-libstdc++ -lmingw32 -mwindows 

SRC_DIR = ./src/
BIN_DIR = ./bin/
BUILD_DIR = ./build/

SRC_FILES = $(wildcard $(SRC_DIR)*.cpp)
OBJ_FILES := $(basename $(SRC_FILES))
OBJ_FILES := $(subst $(SRC_DIR), ,$(OBJ_FILES))
OBJ_FILES := $(addsuffix .o, $(OBJ_FILES))
OBJ_FILES := $(addprefix $(BUILD_DIR), $(OBJ_FILES))

DEPENDENCIES := $(OBJ_FILES)
DEPENDENCIES := $(basename $(DEPENDENCIES))
DEPENDENCIES := $(addsuffix .d, $(DEPENDENCIES))

BIN_FILE = $(BIN_DIR)libmodplug.dll

modplug: $(BIN_FILE)

###########################
$(BIN_FILE): $(OBJ_FILES)
	@echo -Linking libmodplug
	@mkdir -p $(dir $@) >/dev/null
	@$(CXX) $^ $(LDFLAGS) -o $@
###########################

###########################
-include $(DEPENDENCIES)

$(BUILD_DIR)%.o: $(SRC_DIR)%.cpp
	@echo -Compiling $<
	@mkdir -p $(dir $@) >/dev/null
	@$(CXX) $(CXXFLAGS) -I$(SRC_DIR) -o $@ -c $<
	@$(CXX) -MM -MT $@ -I$(SRC_DIR) $< > $(BUILD_DIR)$*.d
###########################

clean:
	@rm -rf $(BIN_DIR)
	@rm -rf $(BUILD_DIR)


.PHONY: modplug clean