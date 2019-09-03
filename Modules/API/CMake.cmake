include_guard(GLOBAL)

#[[ This file holds all overrides for builtin CMake commands ]]

# `project()` has an internal module for use, and it is needed here
# TODO: This *should* be moved to IXM::CMake
import(IXM::Project::*)
import(IXM::Common::Log)

# Overrides project() to do the following:
# 1) Set CMAKE_BUILD_TYPE if not defined
# 2) Detect project blueprints, and load them
# 3) Detect language versions, and set their values as needed.
#    This means that, instead of setting the C++ standard manually,
#    You can declare it inside of LANGUAGES, i.e., CXX14.
# 3 has yet to be implemented
# TODO: Should we consider the first call to project() to be the top level?
# Or should we use CMAKE_PROJECT_NAME? This will affect PROJECT_STANDALONE/"PROJECT_TOPLEVEL"
macro (project name)
  if (NOT CMAKE_BUILD_TYPE)
    log(WARN "CMAKE_BUILD_TYPE not set. Using 'Debug'")
    set(CMAKE_BUILD_TYPE CACHE STRING "Choose the type of build")
  endif()
  ixm_project_blueprint_prepare(${name} ${ARGN})
  # FIXME: We're doing a lot of hacks to get the language values out...
  # Additionally, this is where we should inject support for "enabling"
  # known 'language' packages. This could be done using a temporary
  # append/insert to CMAKE_MODULE_PATH for a Languages/FindXXX.cmake set of files.
  ixm_project_common_language(${name} ${REMAINDER})
  _project(${name} ${REMAINDER})
  unset(REMAINDER)
  # TODO: We need to take all IXM domain properties and put them into the project's
  # TODO: This code should be placed into a separate file and
  # then set to CMAKE_PROJECT_<PROJECT-NAME>_INCLUDE, which is then set by
  # this function.
  list(APPEND build-types ${CMAKE_CONFIGURATION_TYPES})
  list(APPEND build-types ${IXM_CONFIGURATION_TYPES})
  list(APPEND build-types "Debug" "Release" "RelWithDebInfo" "MinSizeRel")
  list(REMOVE_DUPLICATES build-types)
  # This property setting might be removed in the future...
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS ${build-types})
  unset(build-types)
  ixm_project_common_standalone(${name})
  ixm_project_common_version(${name})
  if (DEFINED IXM_CURRENT_BLUEPRINT_NAME)
    ixm_project_blueprint_load(${IXM_CURRENT_BLUEPRINT_NAME})
    include(${IXM_CURRENT_BLUEPRINT_FILE})
    set_property(GLOBAL PROPERTY ${name}_SUBPROJECT_DIR ${PROJECT_SOURCE_DIR})
    set_property(GLOBAL PROPERTY PROJECT_SUBPROJECT_DIR ${PROJECT_SOURCE_DIR})
  endif()
endmacro()

#[[
Used to keep track of custom defined properties so that we can copy them between
targets.
Additionally, serves as a way to store temporary documentation until it can
be fully fleshed out in docs.ixm.one
]]
#function (define_property)
#  _define_property(${ARGV})
#endfunction ()

# With this, we've successfully backported CMAKE_MESSAGE_INDENT, while also
# allowing users to "silence" textual output.
function (message)
  get_property(quiet GLOBAL PROPERTY ixm::print::quiet)
  if (NOT quiet)
    if (CMAKE_VERSION VERSION_LESS 3.16 AND CMAKE_MESSAGE_INDENT)
      list(INSERT ARGV 0 "${CMAKE_MESSAGE_INDENT}")
    endif()
    _message(${ARGV})
  endif()
endfunction()