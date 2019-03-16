find_package(Python COMPONENTS Interpreter Development QUIET)

if (NOT TARGET Python::Interpreter)
  return()
endif()

Find(PROGRAM cython VERSION "Cython version ([0-9]+)[.]([0-9]+)[.]([0-9]+)")

if (TARGET Cython::Cython)
  add_executable(Python::Cython ALIAS Cython::Cython)
endif()

find_package_handle_standard_args(Cython
  REQUIRED_VARS Cython_EXECUTABLE
  VERSION_VAR Cython_VERSION
  HANDLE_COMPONENTS)
