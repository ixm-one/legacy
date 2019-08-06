# Provided so you can simply set `CMAKE_SYSTEM_NAME` to Arduino.
# IXM will automatically include this *unless* CMAKE_TOOLCHAIN_FILE is
# already defined, or if `IXM_CUSTOM_TOOLCHAINS` is false.
# Much like RPi, we need to check for BOTH clang and gcc. Some people might
# not be using the default Arduino IDE toolkit.

if (CMAKE_HOST_WIN32)
  get_filename_component(arduino-sdk-install-path
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\WOW6432Node\\Arduino;Install_Dir]
    ABSOLUTE CACHE)
  set(CMAKE_SYSROOT "${arduino-sdk-install-path}/hardware/tools/avr")
endif()

find_program(CMAKE_ASM_COMPILER avr-gcc)
find_program(CMAKE_CXX_COMPILER avr-g++)
find_program(CMAKE_C_COMPILER avr-gcc)

find_program(CMAKE_RANLIB avr-gcc-ranlib)
find_program(CMAKE_AR avr-gcc-ar)
find_program(CMAKE_NM avr-gcc-nm)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)