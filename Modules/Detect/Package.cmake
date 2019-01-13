include_guard(GLOBAL)
include(FindPackageHandleStandardArgs)

function (ixm_find_hints name)
  string(TOUPPER ${name} pkg)
  set(IXM_FIND_OPTIONS
      ENV ${pkg}_ROOT_DIR
      ENV ${pkg}_DIR
      ENV ${pkg}DIR
      "${${name}_ROOT_DIR}"
      "${${name}_DIR}"
      "${${name}DIR}"
      "${${pkg}_ROOT_DIR}"
      "${${pkg}_DIR}"
      "${${pkg}DIR}")
  ixm_upvar(IXM_FIND_HINTS)
endfunction()

function (find_program_version var)
  ixm_parse(${ARGN}
    @ARGS=? VERSION_FLAG # --version by default
    @ARGS=1 PROGRAM REGEX) # Regex to match against :]
  if (NOT PROGRAM)
    return()
  endif()
  ixm_var(VERSION_FLAG VERSION_FLAG --version)
  # Construct the correct extra flags for us
  execute_process(
    COMMAND ${PROGRAM} ${VERSION_FLAG}
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_STRIP_TRAILING_WHITESPACE
    OUTPUT_VARIABLE output
    ERROR_VARIABLE output)
  # Verify the output!
  string(REGEX MATCH "${REGEX}" matched ${output})
  if (NOT matched)
    return()
  endif()
  # Construct the final version value. If any of these are not capture, we
  # don't have to worry about unnecessary '.' in our output :)
  string(JOIN "." version
    ${CMAKE_MATCH_1}
    ${CMAKE_MATCH_2}
    ${CMAKE_MATCH_3}
    ${CMAKE_MATCH_4})
  set(${var} version PARENT_SCOPE)
endfunction()

macro (check_package package)
  find_package_handle_standard_args(${package} ${ARGN})
  if (NOT ${package}_FOUND)
    return()
  endif()
endmacro()
