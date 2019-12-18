include_guard(GLOBAL)

#[[ This file holds all overrides for builtin CMake commands ]]
import(IXM::Project::*)

list(PREPEND CMAKE_MODULE_PATH "${IXM_ROOT}/Modules/CMake")
include(Backport)
include(Internal)
include(Project)
include(Events)
list(POP_FRONT CMAKE_MODULE_PATH)

#[[
Sadly we cannot simply use the CMAKE_PROJECT_INCLUDE_BEFORE variable.

Overrides project() to do the following:
  1) set CMAKE_BUILD_TYPE if not defined to 'Debug' and *warns* about it
  2) Detect project blueprints and load them/set them
  3) Detect language versions and setting the C++ standard minimum manually.
     i.e., CXX17
]]
macro (project name)
  ixm_cmake_project_prepare(${ARGN})
  _project(${name} ${cmake-sanitized-args})
  unset(cmake-sanitized-args)
  ixm_cmake_project_standalone(${name})
  ixm_cmake_project_version(${name})
  ixm_cmake_project_build_types()
  ixm_cmake_project_blueprint()
endmacro()

#[[ Permit silencing textual output. Backport CHECK_[START|PASS|FAIL] ]]
function (message action)
  aspect(GET print:quiet AS quiet)
  if (quiet)
    return()
  endif()
  if (CMAKE_VERSION VERSION_LESS 3.17 AND action MATCHES "^CHECK_(START|PASS|FAIL)$")
    ixm_cmake_backport_check_progress(${ARGV})
  else()
    _message(${ARGV})
  endif()
endfunction()
