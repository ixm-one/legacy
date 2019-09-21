include(${CMAKE_ROOT}/Modules/CMakeDetermineCompiler.cmake)

include(${CMAKE_CURRENT_LIST_DIR}/${CMAKE_SYSTEM_NAME}-Determine-Go OPTIONAL)
include(${CMAKE_CURRENT_LIST_DIR}/${CMAKE_SYSTEM_NAME}-Go OPTIONAL)

if (NOT CMAKE_Go_COMPILER_NAMES)
  set(CMAKE_Go_COMPILER_NAMES go)
endif()

if (NOT ${CMAKE_GENERATOR} STREQUAL "Ninja")
  message(FATAL_ERROR "Go language not supported by \"${CMAKE_GENERATOR}\" generator")
endif()

if (CMAKE_Go_COMPILER)
  _cmake_find_compiler_path(Go)
else()
  set(CMAKE_Go_COMPILER_INIT NOTFOUND)

  if (DEFINED ENV{GOROOT})
    get_filename_component(CMAKE_Go_COMPILER_INIT "$ENV{GOROOT}/bin/go" PROGRAM)
    if (NOT EXISTS "${CMAKE_Go_COMPILER_INIT}")
      message(FATAL_ERROR "Could not find compiler from environment variable GOROOT\n$ENV{GOROOT}.\n${CMAKE_Go_COMPILER_INIT}")
    endif()
  endif()

  if (NOT CMAKE_Go_COMPILER_INIT)
    set(CMAKE_Go_COMPILER_LIST go gccgo)
  endif()
  _cmake_find_compiler(Go)
endif()
mark_as_advanced(CMAKE_Go_COMPILER)

if (NOT CMAKE_Go_COMPILER_ID_RUN)
  set(CMAKE_Go_COMPILER_ID_RUN 1)

  set(CMAKE_Go_COMPILER_ID)
  include(${CMAKE_ROOT}/Modules/CMakeDetermineCompilerId.cmake)
  cmake_determine_compiler_id(Go "" CompilerId/main.go)

  set(_CMAKE_PROCESSING_LANGUAGE "Go")
  include(CMakeFindBinUtils)
  unset(_CMAKE_PROCESSING_LANGUAGE)
endif()

configure_file(
  ${CMAKE_CURRENT_LIST_DIR}/CMakeGoCompiler.cmake.in
  ${CMAKE_PLATFORM_INFO_DIR}/CMakeGoCompiler.cmake
  @ONLY)


