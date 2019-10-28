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
  if (NOT TARGET test)
    add_custom_target(test
      COMMAND ${CMAKE_CTEST_COMMAND} --progress --output-on-failure)
  endif()
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

# Provided for forwards compatibility
if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.16)
  return()
endif()

# TODO: Call generate(PCH) on <target>
function (target_precompile_headers target)
  void(REUSE_FROM INTERFACE PUBLIC PRIVATE)
  cmake_parse_arguments("" "" "REUSE_FROM" "INTERFACE;PUBLIC;PRIVATE" ${ARGN})
  if (_REUSE_FROM AND (_INTERFACE OR _PUBLIC OR _PRIVATE))
    log(FATAL "Cannot use REUSE_FROM signature with additional arguments")
  endif()
  if (_REUSE_FROM)
    list(LENGTH _REUSE_FROM length)
    if (length GREATER 1)
      log(FATAL "Only one target may be passed to REUSE_FROM")
    endif()
    set_property(TARGET ${target}
      PROPERTY
        PRECOMPILE_HEADERS_REUSE_FROM ${_REUSE_FROM})
    add_dependencies(${target} ${_REUSE_FROM})
    return()
  endif()
  set_property(TARGET ${target}
    APPEND PROPERTY
      INTERFACE_PRECOMPILE_HEADERS ${_INTERFACE} ${_PUBLIC})
  set_property(TARGET ${target}
    APPEND PROPERTY
      PRECOMPILE_HEADERS ${_PRIVATE} ${_PUBLIC})
endfunction()
