include_guard(GLOBAL)

function (ixm_find_program)
  parse(${ARGN}
    @FLAGS DEFAULT
    @ARGS=? COMPONENT VERSION
    @ARGS=* FLAGS HINTS)
  ixm_find_common_check(PROGRAM ${ARGN})
  ixm_find_common_names(program)
  ixm_find_common_hints(hints)

  set(variable ${name}_EXECUTABLE)
  find_program(${variable} NAMES ${REMAINDER} HINTS ${HINTS} ${hints})

  set(required-component ${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED_${COMPONENT})
  set(name ixm::find::${CMAKE_FIND_PACKAGE_NAME})

  if (COMPONENT)
    dict(INSERT ${name} REQUIRED APPEND ${COMPONENT})
  endif()

  if (DEFAULT OR NOT COMPONENT)
    dict(INSERT ${name} VARIABLES APPEND ${variable})
  endif()

  ixm_find_common_append(${variable})
  if (NOT ${variable})
    log(DEBUG "find(PROGRAM): Could not find '${variable}'")
    return()
  endif()

  set(value "${${variable}}")
  mark_as_advanced(${variable})
  add_executable(${program} IMPORTED GLOBAL)
  set_target_properties(${program} PROPERTIES IMPORTED_LOCATION "${value}")
  if (COMPONENT)
    dict(INSERT ${name} ${COMPONENT} APPEND ${variable})
  endif()
  ixm_find_program_version(${value})
endfunction()

#[[ Only ever call this from within ixm_find_program ]]
function (ixm_find_program_version command)
  if (NOT ${name}_VERSION)
    assign(flags ? FLAGS : "--version")
    assign(regex ? VERSION : "[^0-9]+([0-9]+)[.]([0-9]+)?[.]?([0-9]+)?[.]?([0-9]+)?")
    execute_process(COMMAND ${command} ${flags}
      OUTPUT_STRIP_TRAILING_WHITESPACE
      ERROR_STRIP_TRAILING_WHITESPACE
      OUTPUT_VARIABLE output
      ERROR_VARIABLE output)

    string(REGEX MATCH "${regex}.*" matched ${output})
    if (NOT matched)
      return()
    endif()

    string(JOIN "." version
      ${CMAKE_MATCH_1}
      ${CMAKE_MATCH_2}
      ${CMAKE_MATCH_3}
      ${CMAKE_MATCH_4})
    set(docstring "${program} Version")
    set(${name}_VERSION "${version}" CACHE STRING "${docstring}" FORCE)
  endif()

  set_target_properties(${program} PROPERTIES VERSION "${${name}_VERSION}")
endfunction()
