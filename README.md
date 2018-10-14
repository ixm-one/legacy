# Izzy's eXtension Modules

[![License](https://img.shields.io/github/license/slurps-mad-rips/brujeria.svg)](LICENSE.md)

This repo serves as a central location for various CMake modules that make
working with CMake less painful when trying to write Modern *Flexible* CMake.
It is meant to be used as a whole due to intramodule dependencies.
Additionally, it is intended for CMake 3.12 and newer.

# Installation

IXM is intended to be installed in one of the following forms:

|    Method      |
|----------------|
| git submodule  |
| git worktree   |
| `FetchContent` |

Of these, `FetchContent` is the one that is most recommended for flexibility,
as CMake provides a variety of hooks to modify `FetchContent` with nothing more
than variables.

In each scenario, one will call `add_subdirectory()` on the location of the
`ixm` folder. A code sample is provided below for quick copy-pasting into a
project's `CMakeLists.txt`.

## FetchContent

The following code snippet can be copied directly into a `CMakeLists.txt` file.

```cmake
include(FetchContent)
FetchContent_Declare(ixm GIT_REPOSITORY https://github.com/slurps-mad-rips/ixm.git)
FetchContent_GetProperties(ixm)
if(NOT ixm_POPULATED)
  FetchContent_Populate(ixm)
  add_subdirectory(${ixm_SOURCE_DIR})
endif()
```

To enable support for the additional programming language support IXM provides,
this code should be placed before the first call to `project()`, but after the
call to `cmake_minimum_required`. If this support is not needed in the initial
call to `project()`, it should be placed *immediately* after the call to
`project()` and before anything else, except appending to `CMAKE_MODULES_PATH`.
While this might look weird in a well organized `CMakeLists.txt`, it will
handle acquisition of the modules, as well as inclusion to the current
environment. If a future version of CMake provides a wrapper around
`FetchContent` that does the following operation, this snippet can be
simplified.

IXM provides a [git.io] shortcut to reduce the complexity having to remember
the exact git repo. To reach it, simply click [here]. 

Additionally, supporting both the `git` and `FetchContent` forms is
fairly easy. Relying on the `FetchContent` mechanisms, one simply must pass
`-DFETCHCONTENT_SOURCE_DIR_IXM=<path/to/ixm>` when configuring CMake. This will
use the cached download of the repo so that users aren't actually required to
have an internet connection or require that a tool like Docker downloads the
repo everytime.

Lastly, all that the `CMakeLists.txt` does is append the `modules` and
`packages` directories to the `CMAKE_MODULES_PATH` variable. It does nothing
else.

[git.io]: https://git.io
[here]: https://git.io/ixm.git
