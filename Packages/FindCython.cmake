find_package(Python COMPONENTS Interpreter Development QUIET)

if (NOT TARGET Python::Interpreter)
  return()
endif()

Find(PROGRAM cython)
if (TARGET Cython::Cython)
  add_executable(Python::Cython ALIAS Cython::Cython)
endif()
