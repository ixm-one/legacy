include_guard(GLOBAL)

#[[ This file holds all overrides for builtin CMake commands ]]
import(IXM::Project::*)

#[[
Overrides project() to do the following:
  1) set CMAKE_BUILD_TYPE if not defined to 'Debug' and *warns* about it
  2) Detect project blueprints and load them/set them
  3) Detect language versions and setting the C++ standard minimum manually.
     i.e., CXX17
]]
macro (project name)
  if (NOT CMAKE_BUILD_TYPE)
    log(WARN "CMAKE_BUILD_TYPE not set. Using 'Debug'")
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Choose the type of build")
  endif()
  ixm_project_blueprint_prepare(${name} ${ARGN})
  ixm_project_common_language(${name} ${REMAINDER})
  _project(${name} ${REMAINDER})
  unset(REMAINDER)
  ixm_project_common_build_type()
  ixm_project_common_standalone(${name})
  ixm_project_common_version(${name})
  if (DEFINED IXM_CURRENT_BLUEPRINT_NAME)
    ixm_project_blueprint_load(${IXM_CURRENT_BLUEPRINT_NAME})
    include(${IXM_CURRENT_BLUEPRINT_FILE})
    set_property(GLOBAL PROPERTY ${name}_SUBPROJECT_DIR ${PROJECT_SOURCE_DIR})
    set_property(GLOBAL PROPERTY PROJECT_SUBPROJECT_DIR ${PROJECT_SOURCE_DIR})
  endif()
endmacro()

#[[Permit silencing textual output. Backport CMAKE_MESSAGE_INDENT from 3.16]]
function (message)
  aspect(GET print:quiet AS quiet)
  if (NOT quiet)
    if (CMAKE_VERSION VERSION_LESS 3.16 AND CMAKE_MESSAGE_INDENT)
      list(INSERT ARGV 0 "${CMAKE_MESSAGE_INDENT}")
    endif()
    _message(${ARGV})
  endif()
endfunction()
