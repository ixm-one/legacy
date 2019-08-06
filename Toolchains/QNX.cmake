# Provided so you can simply set `CMAKE_SYSTEM_NAME` to QNX and (optionally)
# set `CMAKE_SYSTEM_PROCESSOR` and nothing else will be required.
# IXM will automatically include this file *unless* CMAKE_TOOLCHAIN_FILE is
# already defined, or if "IXM_CUSTOM_TOOLCHAINS" is false.
if (NOT DEFINED ENV{QNX_HOST})
  message(STATUS "QNX_HOST environment variable not found.")
  message(STATUS "  Please run the provided QNX environment script.")
endif()

if (CMAKE_SYSTEM_PROCESSOR STREQUAL "aarch64")
  set(CMAKE_CXX_COMPILER_TARGET gcc_ntoaarch64le)
  set(CMAKE_C_COMPILER_TARGET gcc_ntoaarch64le)
elseif (CMAKE_SYSTEM_PROCESSOR STREQUAL "AMD64")
  set(CMAKE_CXX_COMPILER_TARGET gcc_ntox86_64)
  set(CMAKE_C_COMPILER_TARGET gcc_ntox86_64)
endif()

if (CMAKE_SYSTEM_PROCESSOR STREQUAL CMAKE_HOST_SYSTEM_PROCESSOR)
  set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY)
else()
  set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
  set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
endif()

set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)