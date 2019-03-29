find_package(Python COMPONENTS Interpreter QUIET)
if (NOT TARGET Python::Interpreter)
  return()
endif()

find(PROGRAM sphinx-build)
if (TARGET Sphinx::Sphinx)
  add_executable(Python::Sphinx ALIAS Sphinx::Sphinx)
endif()
