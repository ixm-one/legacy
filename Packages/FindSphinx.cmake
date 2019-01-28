find_package(Python COMPONENTS Interpreter QUIET)
if (NOT TARGET Python::Interpreter)
  return()
endif()

Find(PROGRAM sphinx-build VERSION "sphinx-build ([0-9]+)[.]([0-9]+)[.]([0-9]+)")
if (TARGET Sphinx::Sphinx)
  add_executable(Python::Sphinx ALIAS Sphinx::Sphinx)
endif()
