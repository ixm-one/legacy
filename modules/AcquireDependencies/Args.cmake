include_guard(GLOBAL)

#[[ __common_args()
Calls __minimal_args() as well as setting the following cmake_parse_arguments
options:

  * single: ALIAS TARGET
  * multi POLICIES TARGETS OPTIONS

Most functions in AcquireDependencies will accept these as arguments.
]]
macro (__common_args)
  __minimal_args()
  list(APPEND single ALIAS TARGET)
  list(APPEND multi POLICIES TARGETS OPTIONS)
endmacro()

#[[
Sets the following cmake_parse_arguments options:

 * option: INSTALL QUIET
 * single: ALIAS

All functions in AcquireDependencies will accept these as arguments.
]]
macro (__minimal_args)
  list(APPEND option INSTALL QUIET)
  list(APPEND single ALIAS)
endmacro()

#[[ Run one of the __XXX_args(${ARGN}) functions before running this ]]
macro (__argparse)
  cmake_parse_arguments(ARG "${option}" "${single}" "${multi}" ${ARGN})
endmacro()

#[[ Verifies arguments after __argparse ]]
macro (__verify_args)
  if (DEFINED ARG_TARGET AND DEFINED ARG_TARGETS)
    error("Cannot pass both TARGET and TARGETS")
  endif()
  if (DEFINED ARG_POLICIES)
    foreach (policy IN LIST ARG_POLICIES)
      if (NOT POLICY ${policy})
        error("${policy} is not a valid policy in the form of CMP<NNNN>")
      endif()
    endforeach()
  endif()
endmacro()

#[[ Sets the FetchContent target <name> unless ARG_ALIAS is set ]]
macro (__set_alias name)
  set(alias ${name})
  if (ARG_ALIAS)
    set(alias ${ARG_ALIAS})
  endif()
endmacro()

#[[ sets all options in a key-value pair system ]]
macro (__set_options)
  list(LENGTH ARG_OPTIONS length)
  foreach (begin RANGE 0 ${length} 2)
    list(SUBLIST ARG_OPTIONS ${begin} 2 kv)
    list(GET kv 0 key)
    list(GET kv 1 value)
    if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.13)
      set(${key} ${value})
    else ()
      boolean(${key} ${value})
    endif()
  endforeach()
endmacro()

#[[ TODO: __set_policies ]]

#[[ Allows the install() calls from a subdirectory to be run if ARG_INSTALL
is true ]]
macro (__set_install)
  set(ADD_PACKAGE_ARGS EXCLUDE_FROM_ALL)
  if (ARG_INSTALL)
    unset(ADD_PACKAGE_ARGS)
  endif()
endmacro()

#[[ Sets the target name based on <name>, unless ARG_TARGET is specified
Allows us to know which target to make an add_library(ALIAS) for.
Used in tandem with __set_alias, after calling `add_package`.
Also verifies that the given target is still valid.
]]
macro (__set_target name)
  set(target ${name})
  if (ARG_TARGET)
    set(target ${ARG_TARGET})
  endif()
  # Verification step
  if (NOT TARGET ${target})
    error("TARGET '${target}' is not a valid target")
  endif()
endmacro()

#[[ Allows the Message override function to SILENCE all output ]]
macro (__push_quiet)
  if (ARG_QUIET)
    set(IXM_MESSAGE_QUIET ON)
  endif()
endmacro()

#[[ Resets the QUIET state ]]
macro (__pop_quiet)
  set(IXM_MESSAGE_QUIET OFF)
endmacro()


