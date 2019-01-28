include_guard(GLOBAL)

import(IXM::Project::*)

# No-op so we can have full control over other projects while still generating
# our own test target.
function(enable_testing)
endfunction()

# Override Commands
macro (project name)
  ixm_project_layout(${name} ${ARGN})
  # We also fix the "someone didn't pass in a build type, oh nooooo" problem.
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
  set(PROJECT_STANDALONE OFF)
  if (CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
    set(PROJECT_STANDALONE ON)
  endif()
  global(${name}_SUBPROJECT_DIR ${PROJECT_SOURCE_DIR})
  global(${name}_STANDALONE ${PROJECT_STANDALONE})
  global(PROJECT_SUBPROJECT_DIR ${PROJECT_SOURCE_DIR})
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

# XXX: This belongs in project()
# TODO: Support C files vs CXX files
# TODO: This is *extremely* broken at the moment and I don't know why...
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

  ixm_generate_unity_build_file(${target})
       #  file(GENERATE
       #    OUTPUT $<TARGET_PROPERTY:${target},UNITY_BUILD_FILE>
       #    CONTENT ${content}
       #    CONDITION $<BOOL:$<TARGET_PROPERTY:${target},UNITY_BUILD>>)

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

#[[
Wrapper around Fetch() API so that the given <name> is used as an ALIAS, but
additionally, if it is NOT enabled the value is never fetched. One thing to
keep in mind is that we currently DO NOT support a "choice selection".
This will be changed in the future.
]]
function (With name spec)
endfunction()

#[[
Better "option()" that also adds several defines and variables so that they are
available in the configure header for the project. This is placed into a file
that is generated at generation time, as opposed to configure_file.
]]
function (Feature name help)
endfunction()
