include_guard(GLOBAL)

function (ixm_find_program)
  parse(${ARGN}
    @ARGS=? COMPONENT VERSION
    @ARGS=* FLAGS HINTS)
  ixm_find_common_check(PROGRAM ${ARGN})
  ixm_find_common_names(program)
  ixm_find_common_hints(hints)

  set(variable ${name}_EXECUTABLE)
  find_program(${variable} NAMES ${REMAINDER} HINTS ${HINTS} ${hints})

  if (NOT ${variable})
    return()
  endif()

  set(value "${${variable}}")

  mark_as_advanced(${variable})
  add_executable(${program} IMPORTED GLOBAL)
  set_target_properties(${program} PROPERTIES IMPORTED_LOCATION "${value}")
  dict(INSERT ixm::find::${CMAKE_FIND_PACKAGE_NAME} APPEND PROGRAM ${program})
  if (NOT DEFINED VERSION)
    return()
  endif()
  ixm_find_program_version(${value})
endfunction()

#[[ Only ever call this from within ixm_find_program ]]
function (ixm_find_program_version command)
  if (NOT ${name}_VERSION)
    var(flags FLAGS "--version")
    execute_process(COMMAND ${command} ${flags}
      OUTPUT_STRIP_TRAILING_WHITESPACE
      ERROR_STRIP_TRAILING_WHITESPACE
      OUTPUT_VARIABLE output
      ERROR_VARIABLE output)

    string(REGEX MATCH "${VERSION}.*" matched ${output})
    if (NOT matched)
      return()
    endif()

    string(JOIN "." version
      ${CMAKE_MATCH_1}
      ${CMAKE_MATCH_2}
      ${CMAKE_MATCH_3}
      ${CMAKE_MATCH_4})
    set(docstring "Program '${program}' Version")
    set(${name}_VERSION "${version}" CACHE STRING "${docstring}" FORCE)
  endif()

  set_target_properties(${program} PROPERTIES VERSION "${${name}_VERSION}")
endfunction()
