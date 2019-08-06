# Provided so you can simply set `CMAKE_SYSTEM_NAME` to RaspberryPi.
# Alternatively, you can also set `CMAKE_SYSTEM_NAME` to RPi. IXM is hardcoded
# for its supported toolchains
# IXM will automatically include this file *unless* CMAKE_TOOLCHAIN_FILE is
# already defined, or if `IXM_CUSTOM_TOOLCHAINS` is false.
# Things we need to do
# 1) Detect if clang is set as either CMAKE_CXX_COMPILER or CMAKE_C_COMPILER
# 2) If it is, we need to set the target triple
# 3) Otherwise, we look for the GCC triple instead

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)

if (CMAKE_CXX_COMPILER MATCHES "^.*clang.*$" OR CMAKE_C_COMPILER MATCHES "^.*clang.*$")
  set(CMAKE_CXX_COMPILER_TARGET arm-linux-gnueabihf)
  set(CMAKE_C_COMPILER_TARGET arm-linux-gnueabihf)
endif()

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)