---
date: 2020-02-19 20:00
description: Using CMake to build a LLVM Pass either from source or using a precompiled version of LLVM.
tags: llvm-pass, llvm, cmake
title: Building an out of tree LLVM Pass using CMake
---

## Compiling LLVM vs. using precompiled LLVM libraries

There are two options for creating your own LLVM pass: Your pass can either live directly inside the LLVM source tree or it can live outside in its own tree. In this blog post, I will go into detail about setting up an out of source LLVM pass.

The LLVM documentation suggests using a precompiled version of the LLVM libraries. This does come with some advantages and disadvantages.

![](/images/table.svg)


To make your LLVM pass more flexible your build system should allow building either from source or from the precompiled LLVM libraries.

## Setting up the build system

Building a LLVM pass using the LLVM sources is not as simple as using precompiled LLVM libraries.
LLVMs build system makes use of lots of custom CMake macros which have to be included in your build system for it to work right.

## Building the pass

### Detecting the configuration

First we need to determine if we are building against the LLVM sources or a precompiled version of LLVM.
```cmake
if (NOT PATH_TO_LLVM)
    message(FATAL_ERROR " 
        The cmake is supposed to be called with PATH_TO_LLVM pointing to
        a precompiled version of LLVM or to to the source code of LLVM
        Examples:
        cmake -G \"${CMAKE_GENERATOR}\" -DPATH_TO_LLVM=/opt/llvm-9.0.1 ${CMAKE_SOURCE_DIR}
        cmake -G \"${CMAKE_GENERATOR}\" -DPATH_TO_LLVM=/llvm-project/llvm ${CMAKE_SOURCE_DIR}
    ")
endif()
```
The argument `-DPATH_TO_LLVM` is used to pass the path for the LLVM sources or precompiled libraries to the build system.

```cmake
set (BUILD_AGAINST_PRECOMPILED_LLVM TRUE)
if (EXISTS ${PATH_TO_LLVM}/CMakeLists.txt)
    set (BUILD_AGAINST_PRECOMPILED_LLVM FALSE)
endif()
```
Check if we are using a precompiled LLVM libraries and set `BUILD_AGAINST_PRECOMPILED_LLVM` accordingly.

### Including LLVM CMake macros

Next we need to include the LLVM CMake macros which are used to add libraries (`add_llvm_library`) and executables (`add_llvm_executable`) to LLVM.

```cmake
if (${BUILD_AGAINST_PRECOMPILED_LLVM})
    set (search_paths
        ${PATH_TO_LLVM}
        ${PATH_TO_LLVM}/lib/cmake
        ${PATH_TO_LLVM}/lib/cmake/llvm
        ${PATH_TO_LLVM}/share/llvm/cmake/
    )

find_package(LLVM REQUIRED CONFIG PATHS ${search_paths} NO_DEFAULT_PATH)

list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")

else()

set (LLVM_TARGETS_TO_BUILD "host" CACHE STRING "Only build targets for host architecture" FORCE)

add_subdirectory(${PATH_TO_LLVM} llvm-build)

get_target_property(LLVM_INCLUDE_DIRS LLVMSupport INCLUDE_DIRECTORIES)

list(APPEND CMAKE_MODULE_PATH
    "${PATH_TO_LLVM}/cmake/modules"
)

set(LLVM_MAIN_SRC_DIR ${PATH_TO_LLVM})

endif()
```
If we are using the precompiled LLVM libraries we use `PATH_TO_LLVM` to derive search paths CMake will look for the external project.
`find_package` loads the CMake settings from the precompiled LLVM and allows us to manually add `LLVM_CMAKE_DIR` to the `CMAKE_MODULE_PATH`. Now CMake will find all the macros defined by the precompiled LLVM libraries.

In case we are building from LLVM sources things get a little bit simpler. We just have to create a subdirectory where we want to put the files that are created when building LLVM. We will save the directories containing all LLVM headers in `LLVM_INCLUDE_DIRS` for later use. At the end we again manually add the path to the CMake macros we want to use to  `CMAKE_MODULE_PATH` .

```cmake
include(LLVM-Config)
include(HandleLLVMOptions)
include(AddLLVM)
```
Now we can include the set of CMake modules we want to use in our build system. Those modules will allow us to use LLVM specific CMake functions and macros like `add_llvm_library` and `add_llvm_executable`.

### Including LLVM headers

The directories containing the LLVM headers we saved to `LLVM_INCLUDE_DIRS` before can now be included.
```cmake
include_directories(${LLVM_INCLUDE_DIRS})
```

### Creating our pass

We are using the CMake function `add_llvm_library` to add our pass.
```cmake
add_llvm_library(OutOfTreeLLVMPass MODULE
    Hello.cpp
    DEPENDS
    intrinsics_gen
    PLUGIN_TOOL
    opt
)
```

## Build the pass

After setting up the build system our pass can be built by creating a build directory and running CMake inside the build directory.

### Using sources

Assuming the LLVM sources are located at `../llvm-project/llvm` and our pass is located at `../OutOfTreeLLVMPass`
```
cmake -DPATH_TO_LLVM=../llvm-project/llvm ../OutOfTreeLLVMPass
```

### Using precompiled LLVM libraries

After downloading the precompiled LLVM libraries we can run:
```
cmake -DPATH_TO_LLVM=../clang+llvm-9.0.0-x86_64-darwin-apple ../OutOfTreeLLVMPass
```

Building our pass is now as simple as running:
```
cmake --build .
```

## Further reading

[Template repository](https://github.com/TG908/OutOfTreeLLVMPass)

[LLVM documentation](https://llvm.org/docs/CMake.html#developing-llvm-passes-out-of-source)

[Building an LLVM based tool. Lessosn learned](https://lowlevelbits.org/building-an-llvm-based-tool.-lessons-learned/)


## Feedback

If you have any questions or possible improvements feel free to create a pull request or an issue on [GitHub](https://github.com/TG908/BasicBlog)
