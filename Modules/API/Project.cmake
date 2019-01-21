include_guard(GLOBAL)

import(IXM::Project::*)
import(IXM::API::Prelude)

# Override Commands
macro (project name)
  ixm_project_layout(${name} ${ARGN})
  # We fix the "someone didn't pass in a build type, oh nooooo" problem.
  if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
  endif()
  _project(${name} ${REMAINDER})
  ixm_project_version(${name})
  unset(REMAINDER)
  if (DEFINED IXM_CURRENT_LAYOUT_NAME)
    ixm_project_load_layout(${IXM_CURRENT_LAYOUT_NAME})
    include(${IXM_CURRENT_LAYOUT_FILE})
  endif()
endmacro()

#[[
Adds support for:
 * SERVICE 
 * GUI (WIN32/MACOSX_BUNDLE/APPIMAGE)
 * CONSOLE (APPIMAGE-TERMINAL)
]]
#function(add_executable)
#endfunction()
#

# Custom commands

# Given a directory, it will glob all files and then add them to the given
# target, while still using the unity-build option.
function(target_module)
endfunction()

# Like target_link_libraries, but copies all *known* targets
function(target_copy_properties)
endfunction()

function(target_precompiled_header)
endfunction()

#[[
By importing this module, users are willingly opting into override some builtin
CMake commands.
]]

#[[
Extends the builtin target_sources function to accept glob parameters
automatically. If a file's extension is found to be in the
IXM_CUSTOM_EXTENSIONS global property, we instead attempt to *dynamically*
invoke target_sources_${ext}
]]
function (target_sources target)
  parse(${ARGN}
    @FLAGS RECURSE
    @ARGS=* INTERFACE PUBLIC PRIVATE)
  set(glob GLOB)
  if (RECURSE)
    set(glob GLOB_RECURSE)
  endif()
  if (REMAINDER)
    error(
      "target_sources requires at least"
      "PRIVATE, PUBLIC, or INTERFACE as the second parameter")
  endif()
  get_property(custom-extensions GLOBAL PROPERTY IXM_CUSTOM_EXTENSIONS)
  foreach (visibility IN ITEMS PRIVATE PUBLIC INTERFACE)
    if (NOT DEFINED ${visibility})
      continue()
    endif()
    # Handle globbing for this specific visibility
    foreach (entry IN LISTS ${visibility})
      string(FIND "${entry}" "*" glob-indicator)
      if (glob-indicator GREATER -1)
        file(${glob} entry CONFIGURE_DEPENDS ${entry})
      endif()
      list(APPEND sources ${entry})
    endforeach()
    foreach (extension IN LISTS custom-extensions)
      set(${extension}-sources ${sources})
      list(FILTER ${extension}-sources INCLUDE REGEX ".*[.]${extension}$")
      list(LENGTH ${extension}-sources length)
      if (length GREATER 0)
        list(APPEND extensions ${extension})
        list(REMOVE_ITEM sources ${${extension}-sources})
      endif()
    endforeach()
    foreach (extension IN LISTS extensions)
      if (NOT COMMAND target_sources_${extension})
        error("COMMAND target_sources_${extension} not found")
      endif()
      invoke(target_sources_${extension}
        ${target}
        ${visibility}
        ${${extension}-sources})
    endforeach()
    _target_sources(${target} ${visibility} ${sources})
  endforeach()
endfunction()

#[[
Creates an OBJECT library, and adds the sources found within the given
directory to it. Additionally, a UNITY_BUILD property is set on the target
(to ON unless turned off by the user in the function call or in the properties)
to generate a special source file that allows the "module" to be built as a
unity build.

This can then be extended further with precompiled headers, which are a
separate mechanism.

NOTE: The given name *must* start with the name of an existing TARGET. If the
TARGET does not exist, we give a hard fatal error. The name must use export
style `::`, as this will be used to verify the name of the parent library,
as well as generate an alias target.

The `type` parameter will be one of either SPLAYED or HIERARCHY. In the case of
SPLAYED, the sources given MUST be under a *single* directory, with no
recursing into child directories. The name given to the submodule is NOT
related to the directory that will represent the submodule.  If HIERARCHY is
passed, each component of the `${name}` MUST match the name of a directory.
However, much like the SPLAYED submodule, the HIERARCHY submodule will only
have the scope of files contained within a single directory.

TODO: An enforcement SPLAYED vs HIERARCHY is still needed. Currently they do
nothing.

Lastly, if a submodule with no sources is added, we let CMake complain.
]]

# TODO: Support C files vs CXX files
function (add_submodule name type)
  list(APPEND valid-types SPLAYED HIERARCHY)
  if (NOT type IN_LIST valid-types)
    error("'${type}' is an invalid type of submodule. Valid types are ${valid-types}")
  endif()
  string(REPLACE "::" ";" components ${name})
  list(LENGTH components length)
  list(GET components 0 parent)
  if (length LESS 2)
    error("'${name}' must be scoped to a length of at least two (i.e., foo::bar)")
  endif()

  # How do we want to enforce the name?
  if (NOT TARGET ${parent})
    error("'${name}' contains a parent library '${parent}' that does not exist")
  endif()

  string(REPLACE "::" "-" target ${name})
  string(REPLACE "::" "/" path ${name}.cxx)
  string(REPLACE "::" "." mod ${name})

  # TODO: Enforce SPLAYED vs HIERARCHY

  add_library(${target} OBJECT)
  add_library(${name} ALIAS ${target})

  set(unity-file "${CMAKE_CURRENT_BINARY_DIR}/src/${path}")
  genex(unity-if
    $<IF:$<BOOL:$<TARGET_PROPERTY:${target},UNITY_BUILD>>,
         ${unity-file},
         $<TARGET_PROPERTY:${target},UNITY_SOURCES>>)
  genex(unity
    $<IF:$<BOOL:${IXM_UNITY_BUILD}>,
         ${IXM_UNITY_BUILD},
         ON>)

  get_property(parent-type TARGET ${parent} PROPERTY TYPE)
  set(visibility PRIVATE)
  if (parent-type STREQUAL INTERFACE_LIBRARY)
    set(visibility INTERFACE)
  endif()
  target_sources(${parent}
      ${visibility} $<TARGET_OBJECTS:${target}>)
  target_sources(${target} PRIVATE ${unity-if})

  set_target_properties(${target}
    PROPERTIES
      UNITY_BUILD_FILE ${unity-file}
      UNITY_BUILD ${unity}
      UNITY_SOURCES "${ARGN}"
      MODULE_NAME ${mod})
endfunction()
