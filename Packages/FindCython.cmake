find_package(Python COMPONENTS Interpreter Development QUIET)

if (NOT TARGET Python::Interpreter)
  return()
endif()

find(PROGRAM cython VERSION "Cython version ([0-9]+)[.]([0-9]+)[.]([0-9]+)")

if (TARGET Cython::Cython)
  add_executable(Python::Cython ALIAS Cython::Cython)
endif()
