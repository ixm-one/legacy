#[[
Provided so you can simply set `CMAKE_SYSTEM_NAME` to Android and (optionally)
set `CMAKE_SYSTEM_PROCESSOR` and nothing else will be required.
]]
set(x86_64 "x86_64" "AMD64")
set(arm "armv7a" "arm")

if (CMAKE_HOST_WIN32 AND NOT DEFINED CMAKE_ANDROID_NDK)
  get_filename_component(android-ndk-registry
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Android SDK Tools;Path]
    ABSOLUTE CACHE)
  if (EXISTS "${android-ndk-registry}")
    set(CMAKE_ANDROID_NDK "${android-ndk-install-path}")
  elseif (EXISTS "$ENV{LOCALAPPDATA}/Android/sdk/ndk-bundle")
    set(CMAKE_ANDROID_NDK "$ENV{LOCALAPPDATA}/Android/sdk/ndk-bundle")
  elseif (EXISTS "$ENV{PROGRAMDATA}/Microsoft/AndroidNDK")
    set(CMAKE_ANDROID_NDK "$ENV{PROGRAMDATA}/Microsoft/AndroidNDK")
  endif()
elseif (CMAKE_HOST_APPLE AND NOT DEFINED CMAKE_ANDROID_NDK)
  if (EXISTS "$ENV{HOME}/Library/Android/sdk/ndk-bundle")
    set(CMAKE_ANDROID_NDK "$ENV{HOME}/Library/Android/sdk/ndk-bundle")
  endif()
endif()

# Catch all if the above do not work
if (NOT DEFINED CMAKE_ANDROID_NDK AND DEFINED ENV{ANDROID_SDK_HOME})
  set(CMAKE_ANDROID_NDK "$ENV{ANDROID_SDK_HOME}")
endif()

if (CMAKE_SYSTEM_PROCESSOR STREQUAL "aarch64")
  set(CMAKE_ANDROID_ARCH_ABI arm64-v8a)
elseif (CMAKE_SYSTEM_PROCESSOR STREQUAL "x86")
  set(CMAKE_ANDROID_ARCH_ABI x86)
elseif (CMAKE_SYSTEM_PROCESSOR IN_LIST x86_64)
  set(CMAKE_ANDROID_ARCH_ABI x86_64)
elseif (CMAKE_SYSTEM_PROCESSOR IN_LIST arm)
  set(CMAKE_ANDROID_ARCH_ABI armeabi-v7a)
endif()

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

void(x86_64 arm)