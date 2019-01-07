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
set(test_obj "${test_file}.${CMAKE_Cython_HOST_EXTENSION}")

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

include(Dump)

# Because we can't compile correctly unless we also have a C++ compiler,
# We *run* the tool first, but then use the output to do a try_compile.
execute_process(COMMAND
  ${CMAKE_Cython_COMPILER}
  -${CMAKE_Cython_SYNTAX}
  ${CMAKE_Cython_CXX}
  --embed # So we don't have to rock the boat
  -o "${test_obj}"
  "${test_file}"
  RESULT_VARIABLE CMAKE_Cython_COMPILER_WORKS
  OUTPUT_VARIABLE __Cython_COMPILER_OUTPUT
  ERROR_VARIABLE __Cython_COMPILER_OUTPUT)

dump(CMAKE_Cython_COMPILER_WORKS)

if (NOT CMAKE_Cython_COMPILER_WORKS)
  set(_original ${CMAKE_TRY_COMPILE_TARGET_TYPE})
  set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
  if (MINGW AND CMAKE_Cython_CXX)
    set(__hack COMPILE_DEFINITIONS -D_hypot=hypot)
  endif()
  try_compile(CMAKE_Cython_COMPILER_WORKS ${CMAKE_BINARY_DIR} "${test_obj}"
    CMAKE_FLAGS "-DINCLUDE_DIRECTORIES:STRING=${Python_INCLUDE_DIRS}"
    ${__hack}
    OUTPUT_VARIABLE __Cython_COMPILER_OUTPUT)
  set(CMAKE_TRY_COMPILE_TARGET_TYPE ${_original})
endif()

set(CMAKE_Cython_COMPILER_WORKS ${CMAKE_Cython_COMPILER_WORKS})
unset(CMAKE_Cython_COMPILER_WORKS CACHE)
set(Cython_TEST_WAS_RUN 1)

if (NOT CMAKE_Cython_COMPILER_WORKS)
  PrintTestCompilerStatus("Cython" " -- broken")
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
  ${CMAKE_CURRENT_LIST_DIR}/CMakeCythonCompiler.cmake.in
  ${CMAKE_PLATFORM_INFO_DIR}/CMakeCythonCompiler.cmake
  @ONLY)
include(${CMAKE_PLATFORM_INFO_DIR}/CMakeCythonCompiler.cmake)

unset(__Cython_COMPILER_OUTPUT)
