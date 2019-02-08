include_guard(GLOBAL)

import(IXM::Project::*)

# General Project Functions
# These include overrides, new "target" types, etc.

# Override Commands
macro (project name)
  # We fix the "someone didn't pass in a build type, oh nooooo" problem.
  if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
  endif()
  ixm_project_layout_prepare(${name} ${ARGN})
  _project(${name} ${REMAINDER})
  unset(REMAINDER)
  ixm_project_common_standalone(${name})
  ixm_project_common_version(${name})
  if (DEFINED IXM_CURRENT_LAYOUT_NAME)
    ixm_project_layout_load(${IXM_CURRENT_LAYOUT_NAME})
    include(${IXM_CURRENT_LAYOUT_FILE})
    global(${name}_SUBPROJECT_DIR ${PROJECT_SOURCE_DIR})
    global(PROJECT_SUBPROJECT_DIR ${PROJECT_SOURCE_DIR})
  endif()
endmacro()

#[[ Adds support for the following options:
 * SERVICE (for background processes) # TODO (Windows Service support is needed)
 * GUI (WIN32/MACOSX_BUNDLE/APPIMAGE)
 * CONSOLE
]]
function(add_executable name)
  set(references ALIAS IMPORTED)
  parse(${ARGN} @FLAGS CONSOLE SERVICE GUI)
  _add_executable(${name} ${REMAINDER})
  if (NOT ARGN)
    return()
  endif()
  list(GET ARGN 0 type)
  if (type IN_LIST references)
    return()
  endif()
  if (GUI)
    set_target_properties(${name}
      PROPERTIES
        MACOSX_BUNDLE ON
        WIN32_EXECUTABLE ON
        APPIMAGE ON)
  endif()
  if (CONSOLE)
    set_target_properties(${name} PROPERTIES APPIMAGE_TERMINAL ON)
  endif()
  if (SERVICE)
    error("SERVICE option not yet implemented for IXM")
  endif()
endfunction()

function (add_test)
  if (NOT ARGN)
    error("add_test() requires at least one parameter")
  endif()
  parse(${ARGN}
    @ARGS=? NAME WORKING_DIRECTORY
    @ARGS=* COMMAND CONFIGURATIONS)
  if (NOT NAME)
    _add_test(${ARGN})
    return()
  endif()
  if (NAME)
    _add_test(${ARGN})
    return()
  endif()
endfunction()

#[[
A special type of `add_executable()`. When cross compiling, these targets will
be built as native executables and then IMPORTED into the cross-compiling
build. This improves the ability to have self bootstrapping builds, as well
as code generation for cross compiling. That said, the operations we take tend
to be a bit slower in a cross compiling build. There is, unfortunately, no
way to prevent that. Additionally, tools are
1) Not installable targets
2) Never GUI targets

They are only permitted to be used as *part* of the cross compiling build.
]]

function (add_tool name)
  error("Not yet implemented")
endfunction()

#[[
Creates an OBJECT library, and adds the sources found within the given
directory to it. Additionally, a UNITY_BUILD property is set on the target
to generate a special source file that allows the "module" to be built as a
unity build. Additionally, if any headers with a base name of "mod" or "module"
are found in the directory, a precompiled header will be set on the target.

The ${type} parameter must be one of either SPLAYED or HIERARCHY.

If the type is SPLAYED, the sources given MUST be under a *single* directory.
Additionally, IXM will not recurse into subdirectories, nor will it generate
targets. Lastly, the name given will not be enforced as a submodule if greater
than a depth of 1.

If the type is HIERARCHY, each component of ${name} MUST match the name of a
directory. Additionally, child directories will be recursed into, and
additional submodules will be generated.

The unity build can be disabled by using the NO_UNITY flag.
The precompiled header can be disabled by using the NO_PCH flag.
Passing a generator expression via WHEN means the submodule will only
be built when the condition is satisfied.

add_submodule(project::submodule
  WHEN $<PLATFORM_ID:Windows>)

]]
function (add_submodule name type)
  set(valid-types SPLAYED HIERARCHY)
  if (NOT type IN_LIST valid-types)
    error("'${type}' is an invalid submodule type.")
  endif()
  string(REPLACE "::" ";" components ${name})
  list(LENGTH components length)
  list(GET components 0 parent)
  if (length LESS 2)
    error("'${name}' must be scoped to a length of at least two (i.e., foo::bar)")
  endif()

  if (NOT TARGET ${parent})
    error("'${name}' contains non-existant parent module '${parent}'")
  endif()

  string(REPLACE "::" "-" target ${name})
  string(REPLACE "::" "/" path ${name}.cxx)
  string(REPLACE "::" "." mod ${name})

  add_library(${target} OBJECT)
  add_library(${name} ALIAS ${target})

  set(unity-file "${CMAKE_CURRENT_BINARY_DIR}/src/${path}")
  genex(unity-if
    $<IF:$<BOOL:$<TARGET_PROPERTY:${target},UNITY_BUILD>>,
         ${unity-file},
         $<TARGET_PROPERTY:${target},UNITY_SOURCES>>)

  # OLD!
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

# Custom commands

#[[
TODO: An enforcement SPLAYED vs HIERARCHY is still needed. Currently they do
nothing.

Lastly, if a submodule with no sources is added, we let CMake complain.
]]

#[[
Wrapper around Fetch() API so that the given <name> is used as an ALIAS, but
additionally, if it is NOT enabled the value is never fetched.
]]
function (With name)
  string(TOUPPER "${PROJECT_NAME}_WITH_${name}" option)
  list(LENGTH ARGN length)
  if (length LESS 1)
    error("With() requires at least one Fetch() Dependency reference")
  endif()
  list(GET ARGN 0 default)
  ixm_fetch_prepare_parameters(${default})
endfunction()

#[[
Better "option()" that also adds several defines and variables so that they are
available in the configure header for the project. This is placed into a file
that is generated at generation time, as opposed to configure_file.
]]
function (Feature name help)
endfunction()
