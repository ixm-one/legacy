include_guard(GLOBAL)

import(IXM::API::Property) # TODO: This needs to be moved so the dependencies are correct...
import(IXM::Project::*)

# General Project Functions
# These include overrides, new "target" types, etc.

# TODO: This needs to be replicated elsewhere somehow. Possibly via
# target(UNITY)
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
  assign(alias ? ALIAS : ${name})
  assign(dict ? DICT : ${PROJECT_NAME}::fetch::${name})
  string(TOUPPER "${PROJECT_NAME}_WITH_${name}" option)
  option(${option} "Build ${PROJECT_NAME} with ${name} support")
  if (${option})
    fetch(${dependency} ALIAS ${alias} DICT ${dict})
  endif()
  set(${alias}_SOURCE_DIR ${${alias}_SOURCE_DIR} PARENT_SCOPE)
  set(${alias}_BINARY_DIR ${${alias}_BINARY_DIR} PARENT_SCOPE)
endfunction()

#[[
Better "option()" that also adds several defines and variables so that they are
available in the configure header for the project. This is placed into a file
that is generated at generation time, as opposed to configure_file. This speeds
up project configuration and generation.
If a feature is "public", then it is added to the header file
If a feature is "private", then it is added to the given target only
If a feature is "internal", then it is added as a compile_definition to the
project's "internal" target, which is linked to *all* project targets privately
]]
function (feature name help)
  string(TOUPPER "${PROJECT_NAME}_ENABLE_${name}" option)
  option("${option}" "Build ${PROJECT_NAME} with ${name} enabled")
  dict(INSERT ixm::${PROJECT_NAME} FEATURE APPEND ${name})
endfunction()
