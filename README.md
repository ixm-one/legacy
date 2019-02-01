# Izzy's eXtension Modules

[![License](https://img.shields.io/github/license/slurps-mad-rips/ixm.svg)](LICENSE.md)

This repo serves as a central location for various CMake modules that make
working with CMake less painful when trying to write Modern *Flexible* CMake.
It is meant to be used as a whole due to intramodule dependencies.
Additionally, it is intended for CMake 3.13 and newer.

# Installation

IXM is intended to be installed via the `FetchContent` CMake Module. A code
sample is provided below for quick copy-pasting into a project's
`CMakeLists.txt`.

If using a custom local version

## FetchContent

If using CMake 3.14 or greater, please use the following code snippet at the
top of your root `CMakeLists.txt`.

```cmake
cmake_minimum_required(VERSION 3.14)
include(FetchContent)
FetchContent_Declare(ixm URL https://hub.aliasa.io/slurps-mad-rips/ixm)
FetchContent_MakeAvailable(ixm)
```

If using CMake 3.13, use the following snippet:


```cmake
cmake_minimum_required(VERSION 3.13)
include(FetchContent)
FetchContent_Declare(ixm URL https://hub.aliasa.io/slurps-mad-rips/ixm)
FetchContent_GetProperties(ixm)
if(NOT ixm_POPULATED)
  FetchContent_Populate(ixm)
  add_subdirectory(${ixm_SOURCE_DIR} ${ixm_BINARY_DIR})
endif()
```

It is recommended to use CMake 3.14 for greater benefits. Additionally, the
1.0 release of IXM may use 3.14 as the minimum target.

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

# Bootstrapping for CMake

While not all platforms supply a modern version of CMake, they do typically
provide a recent version of Python 3.5+ and Pip. If this is available on your
system, run the following commands (where pip is the appropriate level of
permissions and the correct pip3 command):

```sh
<pip-command> install --upgrade cmake ninja setuptools pip
```

This will install the minimum set of modern CMake tools needed for you to
use IXM. After this, just make sure these versions of `cmake` and `ninja` are
on your system path.

## RHEL

Redhat and Redhat based systems, such as CentOS, do not come with a new python
by default. However, thanks to an official SCL collection, one can install 
python 3.6 and later. To use IXM on these platforms, perform the following
operations at a minimum:

```sh
yum install rh-python36
scl enable rh-python36 bash
python3 -m pip install --upgrade setuptools pip cmake ninja
```

[git.io]: https://git.io
[here]: https://git.io/ixm.git
