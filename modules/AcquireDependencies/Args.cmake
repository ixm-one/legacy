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
  list(APPEND single TARGET)
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

#[[ Solves a small problem with duplicate keywords for options ]]
macro (__unique_args)
  list(REMOVE_DUPLICATES option)
  list(REMOVE_DUPLICATES single)
  list(REMOVE_DUPLICATES multi)
endmacro()

#[[ Run one of the __XXX_args(${ARGN}) functions before running this ]]
macro (__argparse)
  __unique_args()
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

#[[ sets all options in a key-value pair system ]]
function (apply_settings settings)
  if (NOT settings)
    return()
  endif()
  list(LENGTH settings length)
  math(EXPR length "${length} - 1")
  foreach (begin RANGE 0 ${length} 2)
    list(SUBLIST settings ${begin} 2 kv)
    list(GET kv 0 key)
    list(GET kv 1 value)
    if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.13)
      set(${key} ${value})
    else ()
      boolean(${key} ${value})
    endif()
  endforeach()
endfunction()

#[[ Sets all policies in a key-value pair system ]]
# TODO: How often would this actually be needed?
function (apply_policies policies)
  if (NOT policies)
    return()
  endif()
  list(LENGTH policies length)
  math(EXPR length "${length} - 1")
  foreach (begin RANGE 0 ${length} 2)
    list(SUBLIST policies ${begin} 2 kv)
    list(GET kv 0 key)
    list(GET kv 1 value)
  endforeach()
endfunction()
