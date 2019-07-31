include_guard(GLOBAL)

import(IXM::API::Property) # TODO: This needs to be moved so the dependencies are correct...
import(IXM::Project::*)

# General Project Functions
# These include overrides, new "target" types, etc.

# Override Commands
# TODO: Support pulling from IXM's toolchain files by simply stating a name as
# the value. e.g., -DIXM/CMAKE_TOOLCHAIN_NAME=<target-triple>
macro (project name)
  # We fix the "someone didn't pass in a build type, oh nooooo" problem.
  if (NOT CMAKE_BUILD_TYPE)
    warning("CMAKE_BUILD_TYPE not set. Using 'Debug'")
    cache(STRING CMAKE_BUILD_TYPE Debug)
  endif()
  ixm_project_blueprint_prepare(${name} ${ARGN})
  _project(${name} ${REMAINDER})
  unset(REMAINDER)
  ixm_project_common_standalone(${name})
  ixm_project_common_version(${name})
  if (DEFINED IXM_CURRENT_BLUEPRINT_NAME)
    ixm_project_blueprint_load(${IXM_CURRENT_BLUEPRINT_NAME})
    include(${IXM_CURRENT_BLUEPRINT_FILE})
    global(${name}_SUBPROJECT_DIR ${PROJECT_SOURCE_DIR})
    global(PROJECT_SUBPROJECT_DIR ${PROJECT_SOURCE_DIR})
  endif()
endmacro()

#[[Adds a executable intended to run in a terminal as a target]]
function(executable name)
  set(ixm::add::executable "${name}")
  parse(${ARGN} @FLAGS CONSOLE SERVICE GUI)
  add_executable(${name})
  if (REMAINDER)
    target_sources(${name} PRIVATE ${REMAINDER})
  endif()
  if ((CONSOLE AND GUI) OR (CONSOLE AND SERVICE) OR (SERVICE AND GUI))
    error("Only one of CONSOLE, SERVICE, or GUI is permitted")
  endif()
  if (CONSOLE)
    set_target_properties(${name} PROPERTIES APPIMAGE_TERMINAL ON)
  endif()
  if (SERVICE)
    # This is just going to setup a few generator expressions to generate
    # systemd/launchd configuration files.
    error("SERVICE option is not yet implemented for IXM")
  endif()
  if (GUI)
    set_target_properties(${name}
      PROPERTIES
        MACOSX_BUNDLE ON
        WIN32_EXECUTABLE ON
        APPIMAGE ON)
  endif()
  unset(ixm::add::executable)
endfunction()

function (archive name)
  set(ixm::add::archive ${name})
  add_library(${name} STATIC)
  if (ARGN)
    target_sources(${name} PRIVATE ${ARGN})
  endif()
  unset(ixm::add::archive)
endfunction()

function (library name)
  set(ixm::add::library ${name})
  add_library(${name} SHARED)
  if (ARGN)
    target_sources(${name} PRIVATE ${ARGN})
  endif()
  unset(ixm::add::library)
endfunction ()

function (plugin name)
  set(ixm::add::plugin ${name})
  add_library(${name} MODULE)
  if (ARGN)
    target_sources(${name} PRIVATE ${ARGN})
  endif()
  unset(ixm::add::plugin)
endfunction ()

function (object name)
  set(ixm::add::object ${name})
  add_library(${name} OBJECT)
  if (ARGN)
    target_sources(${name} PRIVATE ${ARGN})
  endif()
  unset(ixm::add::object)
endfunction ()

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
  genexp(unity-if
    $<IF:$<BOOL:$<TARGET_PROPERTY:${target},UNITY_BUILD>>,
         ${unity-file},
         $<TARGET_PROPERTY:${target},UNITY_SOURCES>>)

  # OLD!
  genexp(unity
    $<IF:$<BOOL:${IXM_UNITY_BUILD}>,
         ${IXM_UNITY_BUILD},
         ON>)
  ixm_target_generate_unity(${target})

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
Wrapper around fetch() API so that the given <name> is used as an ALIAS, but
additionally, if it is NOT enabled the value is never fetched.
]]
function (with name dependency)
  parse(${ARGN} @ARGS=? ALIAS DICT)
  var(alias ALIAS ${name})
  var(dict DICT ixm::fetch::${name})
  string(TOUPPER "${PROJECT_NAME}_WITH_${name}" option)
  option(${option} "Build ${PROJECT_NAME} with ${name} support")
  if (${option})
    fetch(${dependency} ALIAS ${alias} DICT ${dict})
  endif()
  upvar(${alias}_SOURCE_DIR ${alias}_BINARY_DIR)
endfunction()

#[[
Better "option()" that also adds several defines and variables so that they are
available in the configure header for the project. This is placed into a file
that is generated at generation time, as opposed to configure_file. This speeds
up project configuration and generation.
]]
function (feature name help)
  string(TOUPPER "${PROJECT_NAME}_ENABLE_${name}" option)
  option("${option}" "Build ${PROJECT_NAME} with ${name} enabled")
  dict(INSERT ixm::${PROJECT_NAME} FEATURE APPEND ${name})
endfunction()
