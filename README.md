The issue appears to be that, when compiling/linking many files, the swiftc compiler ends up putting the command line parameters for the link step into a temporary response file.  The problem is that the first parameter is "/LIB", which demands to be the first parameter in the list.  However, because "/LIB" is in the response file, it is not read properly.  If it's taken out of the response file, and put onto the command line, then the link step works as expected.

This issue has been reproduced with swiftc version 5.8.1.

## To Build:

    mkdir .build
    cmake --debug-trycompile -B .build -G Ninja -DCMAKE_BUILD_TYPE=Debug .
    ninja -C .build -v
    ...
    "Sources\\CMakeFiles\\DummyLibrary.dir\\DummyFiles\\Dummy99.swift.obj"
    "Sources\\CMakeFiles\\DummyLibrary.dir\\MoreDummyFiles\\468_Dummy44.swift.obj"
    LINK : warning LNK4044: unrecognized option '/LIB'; ignored
    LINK : fatal error LNK1561: entry point must be defined
    ninja: build stopped: subcommand failed.    

## Further Analysis

### Running the ninja command results in the following swiftc command:

    C:\Library\Developer\Toolchains\unknown-Asserts-development.xctoolchain\usr\bin\swiftc.exe -j 24 -num-threads 24 -emit-library -static -o lib\DummyLibrary.lib -module-name DummyLibrary -module-link-name DummyLibrary -emit-module -emit-module-path swift\DummyLibrary.swiftmodule -emit-dependencies  -Onone -g -incremental -libc MDd -output-file-map Sources\CMakeFiles\DummyLibrary.dir\Debug\output-file-map.json  @CMakeFiles\DummyLibrary.rsp

### Running the swiftc command with "-save-temps -v" results in the following commands:

    C:\Library\Developer\Toolchains\unknown-Asserts-development.xctoolchain\usr\bin\swiftc.exe -save-temps -v -j 24 -num-threads 24 -emit-library -static -o lib\DummyLibrary.lib -module-name DummyLibrary -module-link-name DummyLibrary -emit-module -emit-module-path swift\DummyLibrary.swiftmodule -emit-dependencies  -Onone -g -incremental -libc MDd -output-file-map Sources\CMakeFiles\DummyLibrary.dir\Debug\output-file-map.json  @CMakeFiles\DummyLibrary.rsp
    ..
    compnerd.org Swift version 5.8.1 (swift-5.8.1-RELEASE)
    Target: x86_64-unknown-windows-msvc
    C:\Library\Developer\Toolchains\unknown-Asserts-development.xctoolchain\usr\bin\swift-frontend.exe @C:\Users\buildmaster\AppData\Local\Temp\TemporaryDirectory.chqGAZ\arguments-4654575299439006942.resp

    C:\Library\Developer\Toolchains\unknown-Asserts-development.xctoolchain\usr\bin\swift-frontend.exe -modulewrap swift\DummyLibrary.swiftmodule -target x86_64-unknown-windows-msvc -o swift\DummyLibrary.o

    C:\BuildTools\VC\Tools\MSVC\14.29.30133\bin\HostX64\x64\link.exe @C:\Users\buildmaster\AppData\Local\Temp\TemporaryDirectory.chqGAZ\arguments-7492443228980014747.resp
    error: link command failed with exit code 1561 (use -v to see invocation)

It is (in this case) the response file, arguments-7492443228980014747.resp, which contains the "/LIB" parameter.  If it were removed from the top of the response file, and put on the command line instead, then the link stage would succeed.

### Note:

This issue seems to somewhat be contingent on command line length.  The example needed to contain many source files in order for the problem to occur. Commenting out the "GLOB MORE_DUMMY_SOURCES" line in 'Sources/CMakeLists.txt' is enough to make the problem go away.
