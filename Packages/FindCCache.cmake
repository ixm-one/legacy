import(IXM::Detect::Package)

ixm_find_hints(CCache)
find_program(CCache_EXECUTABLE NAMES ccache HINTS ${IXM_FIND_HINTS})

if (CCache_EXECUTABLE)
  execute_process(COMMAND ${CCache_EXECUTABLE} --version)
endif()

check_package(CCache
  REQUIRED_VARS CCache_EXECUTABLE
  VERSION_VAR CCache_VERSION)

if (NOT CCache_FOUND)
  return()
endif()

mark_as_advanced(CCache_EXECUTABLE)
add_executable(CCache IMPORTED GLOBAL)
set_target_properties(CCache PROPERTIES IMPORTED_LOCATION ${CCACHE_EXECUTABLE})
