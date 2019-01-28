find_package(Python COMPONENTS Interpreter QUIET)

if (NOT TARGET Python::Interpreter)
  return()
endif()
Find(PROGRAM poetry)
if (TARGET Poetry::Poetry)
  add_executable(Python::Poetry ALIAS Poetry::Poetry)
endif()
