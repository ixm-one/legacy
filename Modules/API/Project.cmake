include_guard(GLOBAL)

import(IXM::Project::*)

# This unfortunately MUST be a macro or else MANY THINGS will break
macro (project name)
  ixm_project_layout(${name} ${ARGN})
  if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
  endif()
  _project(${name} ${REMAINDER})
  unset(REMAINDER)
  if (DEFINED IXM_CURRENT_LAYOUT_NAME)
    ixm_project_load_layout(${IXM_CURRENT_LAYOUT_NAME})
    include(${IXM_CURRENT_LAYOUT_FILE})
  endif()
endmacro()
