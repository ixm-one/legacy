find_package(Python COMPONENTS Interpreter QUIET)

if (NOT TARGET Python::Interpreter)
  return()
endif()

list(APPEND pip-names
  "${Python_VERSION_MAJOR}${Python_VERSION_MINOR}"
  "${Python_VERSION_MAJOR}")
list(TRANSFORM names PREPEND pip)
list(APPEND names pip)

Find(PROGRAM ${pip-names})
if (TARGET Pip::Pip)
  add_executable(Python::Pip ALIAS Pip::Pip)
endif()
