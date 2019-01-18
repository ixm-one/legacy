include_guard(GLOBAL)

import(IXM::Project::*)

# This unfortunately MUST be a macro or else MANY THINGS will break
macro (project name)
  ixm_project_layout(${name} ${ARGN})
  # We fix the "someone didn't pass in a build type, oh nooooo" problem.
  if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
  endif()
  _project(${name} ${REMAINDER})
  # Cython is a strange beast, and to avoid recursive enable language calls,
  # we need to do it AFTER project() has been called :/
  if (IXM_ENABLE_CYTHON)
    enable_language(Cython)
  endif()
  unset(REMAINDER)
  unset(IXM_ENABLE_CYTHON)
  if (DEFINED IXM_CURRENT_LAYOUT_NAME)
    ixm_project_load_layout(${IXM_CURRENT_LAYOUT_NAME})
    include(${IXM_CURRENT_LAYOUT_FILE})
  endif()
endmacro()
