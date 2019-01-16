include_guard(GLOBAL)

#[[
By importing this module, users are willingly opting into override some builtin
CMake commands.
]]

#[[
Extends the builtin target_sources function to accept glob parameters
automatically.
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
    error("target_sources requires at least PRIVATE, PUBLIC, or INTERFACE")
  endif()
  foreach (var IN ITEMS PRIVATE PUBLIC INTERFACE)
    if (NOT DEFINED ${var})
      continue()
    endif()
    foreach (entry IN LISTS ${var})
      string(FIND "${entry}" "*" glob_indicator)
      if (glob_indicator GREATER -1)
        file(${glob} entry CONFIGURE_DEPENDS ${entry})
      endif()
      list(APPEND sources ${entry})
    endforeach()
    _target_sources(${target} ${var} ${sources})
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

cache(BOOL IXM_UNITY_BUILD ON)

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
