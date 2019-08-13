# Provided so you can simply set `CMAKE_SYSTEM_NAME` to RaspberryPi.
# Alternatively, you can also set `CMAKE_SYSTEM_NAME` to RPi. IXM is hardcoded
# for its supported toolchains
# IXM will automatically include this file *unless* CMAKE_TOOLCHAIN_FILE is
# already defined, or if `IXM_CUSTOM_TOOLCHAINS` is false.
# Things we need to do
# 1) Detect if clang is set as either CMAKE_CXX_COMPILER or CMAKE_C_COMPILER
# 2) If it is, we need to set the target triple
# 3) Otherwise, we look for the GCC triple instead
# Additionally, we need a way to know if someone is targeting the Raspberry Pi
# Zero or v1. This could be handled with something like CMAKE_SYSTEM_VERSION
# or something similar.
# Of particular note: There are many possible cross compiler configurations
# available for RPi. Specifically, RPi v2 and later support ARMv8-A. They also
# are all AArch32 which is Armv7 compatible. Hence, a lot more work is needed
# to get all possible GCC toolchains working with RPi.
# One other thing to possibly take into account is if the CMAKE_SYSTEM_NAME
# should always be set to Linux, as FreeBSD on the RPi is supported as well.
# Thus, we shouldn't set it if it hasn't been set already.

if (NOT DEFINED CMAKE_SYSTEM_NAME)
  set(CMAKE_SYSTEM_NAME Linux)
endif()

# Probably not correct if using gcc vs clang :/
if (NOT DEFINED CMAKE_SYSTEM_PROCESSOR)
  if (CMAKE_SYSTEM_VERSION VERSION_LESS_EQUAL 1)
    set(CMAKE_SYSTEM_PROCESSOR armv6)
  elseif (CMAKE_SYSTEM_VERSION VERSION_LESS 3)
    set(CMAKE_SYSTEM_PROCESSOR armv7)
  elseif (CMAKE_SYSTEM_VERSION VERSION_EQUAL 3)
    set(CMAKE_SYSTEM_PROCESSOR armv7-a)
  elseif (CMAKE_SYSTEM_VERSION VERSION_LESS_EQUAL 4)
    set(CMAKE_SYSTEM_PROCESSOR arm64)
  else()
    set(CMAKE_SYSTEM_PROCESSOR armv7)
  endif()
endif()

if (CMAKE_CXX_COMPILER MATCHES "^.clang.*$" OR CMAKE_C_COMPILER MATCHES "^.clang.*$")
  if (NOT CMAKE_SYSTEM_PROCESSOR STREQUAL "arm64")
    set(abi eabihf)
  endif()
  set(CMAKE_CXX_COMPILER_TARGET "${CMAKE_SYSTEM_PROCESSOR}-linux-gnu${abi}")
  set(CMAKE_C_COMPILER_TARGET "${CMAKE_SYSTEM_PROCESSOR}-linux-gnu${abi}")
  unset(abi)
endif()

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
