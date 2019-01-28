import(IXM::API::Find)

find_package(Python COMPONENTS Interpreter QUIET)
if (NOT TARGET Python::Interpreter)
  return()
endif()

Find(PROGRAM sphinx-build VERSION "sphinx-build ([0-9]+)[.]([0-9]+)[.]([0-9]+)")
Find(CONFIRM)
