import(IXM::Detect::Package)

ixm_find_hints(SCCache)
find_program(SCCache_EXECUTABLE NAMES sccache ${IXM_FIND_HINTS})
find_program_version(SCCache_VERSION
  PROGRAM "${SCCache_EXECUTABLE}"
  REGEX "sccache ([0-9]+)\.([0-9]+)\.([0-9]+)")

check_package(SCCache
  REQUIRED_VARS SCCache_EXECUTABLE
  VERSION_VAR SCCache_VERSION)

if (NOT SCCache_FOUND)
  return()
endif()

mark_as_advanced(SCCache_EXECUTABLE SCCache_VERSION)
add_executable(SCCache IMPORTED GLOBAL)
set_target_properties(SCCache PROPERTIES IMPORTED_LOCATION ${SCCache_EXECUTABLE})
