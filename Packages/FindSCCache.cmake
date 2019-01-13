import(IXM::Detect::Package)

ixm_find_hints(SCCache)
find_program(SCCache_EXECUTABLE NAMES sccache ${IXM_FIND_HINTS})
if (SCCache_EXECUTABLE)
  execute_process(
    COMMAND ${SCCache_EXECUTABLE} --version
    OUTPUT_VARIABLE output)
  string(REGEX MATCH "([0-9]+)\.([0-9]+)\.([0-9]+)" version ${output})
  set(SCCache_VERSION ${version})
endif()

check_package(SCCache
  REQUIRED_VARS SCCache_EXECUTABLE
  VERSION_VAR SCCache_VERSION)

if (NOT SCCache_FOUND)
  return()
endif()

mark_as_advanced(SCCache_EXECUTABLE SCCache_VERSION)
add_executable(SCCache IMPORTED GLOBAL)
set_target_properties(SCCache PROPERTIES IMPORTED_LOCATION ${SCCache_EXECUTABLE})
