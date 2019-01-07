include(${CMAKE_ROOT}/Modules/CMakeDetermineCompiler.cmake)
include(CheckLanguage)

if (NOT (${CMAKE_GENERATOR} MATCHES "Make" OR
         ${CMAKE_GENERATOR} MATCHES "Ninja"))
  message(FATAL_ERROR "Cython language not currently supported by "
    "\"${CMAKE_GENERATOR}\" generator")
endif()

if (CMAKE_CXX_COMPILER_LOADED)
  set(CMAKE_Cython_LANG CXX)
elseif (CMAKE_C_COMPILER_LOADED)
  set(CMAKE_Cython_LANG C)
else()
  if (CMAKE_Cython_PREFER_C)
    check_language(C)
  else()
    check_language(CXX)
  endif()
  if (CMAKE_CXX_COMPILER)
    enable_language(CXX)
    set(CMAKE_Cython_LANG CXX)
  elseif(CMAKE_C_COMPILER)
    enable_language(C)
    set(CMAKE_Cython_LANG C)
  else()
    message(FATAL_ERROR "Cython requires either a C or CXX compiler")
  endif()
endif()

# We can only do these steps *after* we've enabled the C or CXX compiler
find_package(Python COMPONENTS Interpreter Development)
find_package(Cython REQUIRED)

set(CMAKE_Cython_COMPILER ${Cython_EXECUTABLE})
set(CMAKE_Cython_SYNTAX ${Python_VERSION_MAJOR})


# TODO: Change this to HOST_COMPILER, support environment variable
set(CMAKE_Cython_NATIVE_COMPILER ${CMAKE_${LANG}_COMPILER})
set(CMAKE_Cython_COMPILE_SOURCE ${CMAKE_${LANG}_COMPILE_OBJECT})
set(CMAKE_Cython_COMPILER_ENV_VAR "CYTHON")
if (CMAKE_Cython_LANG STREQUAL CXX)
  set(CMAKE_Cython_CXX "--cplus")
endif()
string(TOLOWER "${CMAKE_Cython_LANG}" CMAKE_Cython_HOST_EXTENSION)


configure_file(${CMAKE_CURRENT_LIST_DIR}/CMakeCythonCompiler.cmake.in
  ${CMAKE_PLATFORM_INFO_DIR}/CMakeCythonCompiler.cmake
  @ONLY)
