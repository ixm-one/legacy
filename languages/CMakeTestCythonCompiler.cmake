if (CMAKE_Cython_COMPILER_FORCED)
  set(CMAKE_Cython_COMPILER_WORKS TRUE)
  return()
endif()

include(CMakeTestCompilerCommon)

if (CMake_Cython_COMPILER_WORKS)
  return()
endif()

set(test_root "${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}")
set(test_file "${test_root}/CMakeTmp/testCythonCompiler.pyx")

PrintTestCompilerStatus("Cython" "${CMAKE_Cython_COMPILER}")
file(WRITE ${test_file} [=[
cdef struct Grail:
  int age
  float volume

cdef union Food:
  char* spam
  float *eggs

cdef enum CheeseType:
  cheddar, edam,
  camembert

cpdef enum CheeseState:
  hard = 1
  soft = 2
  runny = 3
]=])

try_compile(CMAKE_Cython_COMPILER_WORKS ${CMAKE_BINARY_DIR} "${test_file}"
  OUTPUT_VARIABLE __Cython_COMPILER_OUTPUT)

set(CMAKE_Cython_COMPILER_WORKS ${CMAKE_Cython_COMPILER_WORKS})
unset(CMAKE_Cython_COMPILER_WORKS CACHE)
set(Cython_TEST_WAS_RUN 1)

if (NOT CMAKE_Cython_COMPILER_WORKS)
  file(APPEND ${test_root}/CMakeError.log
    "Determining if the Cython compiler works failed with "
    "the following output:\n ${__Cython_COMPILER_OUTPUT}")
  string(REPLACE "\n" "\n  " _output "${__CMAKE_CUDA_COMPILER_OUTPUT}")
  message(FATAL_ERROR "The Cython Compiler\n \"${CMAKE_Cython_COMPILER}\"\n"
    "is not able to compile a simple test program.\nIt fails "
    "with the following output:\n ${_output}\n\n"
    "CMake wil not be able to generate this project")
  unset(__Cython_COMPILER_OUTPUT)
  return()
endif()

if (Cython_TEST_WAS_RUN)
  PrintTestCompilerStatus("Cython" " -- works")
  file(APPEND "${test_root}/CMakeOutput.log"
    "Determining if the Cython compiler works passed with "
    "the following output:\n ${__Cython_COMPILER_OUTPUT}")
endif()

configure_file(
  ${CMAKE_CURRENT_LIST_DIR}/CMakeCython.cmake.in
  ${CMAKE_PLATFORM_INFO_DIR}/CMakeCythonCompiler.cmake
  @ONLY)
include(${CMAKE_PLATFORM_INFO_DIR}/CMakeCythonCompiler.cmake)

unset(__Cython_COMPILER_OUTPUT)

