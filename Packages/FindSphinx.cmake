import(IXM::Detect::Package)

find_package(Python COMPONENTS Interpreter QUIET)

if (NOT Python_Interpreter_FOUND)
  return()
endif()

ixm_find_hints(Sphinx)
find_program(Sphinx_EXECUTABLE
  NAMES sphinx-build
  HINTS ${IXM_FIND_HINTS})
find_program_version(Sphinx_VERSION
  PROGRAM "${Sphinx_EXECUTABLE}"
  REGEX "sphinx-build ([0-9]+)[.]([0-9]+)[.]([0-9]+).*")

check_package(Sphinx
  REQUIRED_VARS Sphinx_EXECUTABLE
  VERSION_VAR Sphinx_VERSION)

mark_as_advanced(Sphinx_EXECUTABLE)
add_executable(Sphinx IMPORTED GLOBAL)
add_executable(Python::Sphinx ALIAS Sphinx)
set_target_properties(Sphinx PROPERTIES IMPORTED_LOCATION ${Sphinx_EXECUTABLE})
