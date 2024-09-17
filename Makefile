ifdef VERBOSE
  NINJA_FLAGS := -v
endif

all:
	mkdir -p .build
	cmake --debug-trycompile -B .build -G Ninja -DCMAKE_BUILD_TYPE=Debug .
	ninja -C .build $(NINJA_FLAGS)

clean:
	rm -rf .build
