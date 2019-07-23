include_guard(GLOBAL)

find_package(Cython)

#[[ Checks target for CXX or C to be enabled, then sets the correct language ]]
function (ixm_cython_check_language name)
  get_property(enabled-languages GLOBAL PROPERTY ENABLED_LANGUAGES)
  set(language CXX)
  if (NOT language IN_LIST enabled-languages)
    set(language C)
  endif()
  if (NOT language IN_LIST enabled-languages)
    error("Cython target '${name}' requires CXX or C to be enabled")
  endif()
  set_target_properties(${name}
    PROPERTIES
      CYTHON_OUTPUT_LANGUAGE ${language})
endfunction()

function (ixm_cython_validate_state name)
  ixm_cython_check_language(${name})
  get_property(type TARGET PROPERTY TYPE)
  if (type STREQUAL INTERFACE_LIBRARY)
    error("Cannot create an INTERFACE Cython Module")
  endif()
  if (NOT TARGET Python::Cython)
    error("Cannot create Cython library without Cython package")
  endif()
endfunction()

#[[
This simply creates the cython library. It does not add sources. To add sources
simply use target_sources like normal :)
]]
function (add_cython_library name type)
  Python_add_library(${name} ${type})
  ixm_cython_validate_state(${name})
  set_property(TARGET ${name} PROPERTY CYTHON_LINE_DIRECTIVES ON)

  get_property(language TARGET PROPERTY CYTHON_OUTPUT_LANGUAGE)
  string(TOLOWER ${language} extension)

  genexp(INCLUDE_DIRECTORIES $<
    $<BOOL:$<TARGET_PROPERTY:${name},INCLUDE_DIRECTORIES>>:
    -I
    $<JOIN:
        $<TARGET_PROPERTY:${name},INCLUDE_DIRECTORIES>,
        $<SEMICOLON>-I
    >
  >)

  genexp(COMPILER_DIRECTIVES $<
    $<BOOL:$<TARGET_PROPERTY:${name},CYTHON_COMPILER_DIRECTIVES>>:
    -X$<JOIN:
        $<TARGET_PROPERTY:${name},CYTHON_COMPILER_DIRECTIVES>,
        $<SEMICOLON>-X
      >
  >)
  genexp(CYTHON_CXX $<
    $<STREQUAL:$<TARGET_PROPERTY:CYTHON_OUTPUT_LANGUAGE>,CXX>:--cplus
  >)

  genexp(embed-positions $<$<CONFIG:Debug>:--embed-positions>)
  genexp(language $<$<BOOL:$<CXX_COMPILER_ID>:--cplus>)
  genexp(syntax $<$<BOOL:${Python_VERSION_MAJOR}>:-${Python_VERSION_MAJOR}>)
  genexp(embed $<
    $<STREQUAL:$<TARGET_PROPERTY:${name},TYPE>,EXECUTABLE>:--embed
    $<
      $<BOOL:$<TARGET_PROPERTY:${name},CYTHON_ENTRYPOINT>>:
      =$<TARGET_PROPERTY:${name},CYTHON_ENTRYPOINT>
    >
  >)
  genexp(cleanup $<
    $<BOOL:$<TARGET_PROPERTY:${name},CYTHON_CLEANUP_LEVEL>:
    --cleanup $<TARGET_PROPERTY:${name},CYTHON_CLEANUP_LEVEL>
  >)
  genexp(debug $<$<CONFIG:Debug>:--gdb>)
  genexp(line-directives $<
    $<BOOL:$<TARGET_PROPERTY:${name},CYTHON_LINE_DIRECTIVES>>:--line-directives
  >)
  set(output-file ${CMAKE_CURRENT_BINARY_DIR}/IXM/Cython/${name}.${extension})

  add_custom_command(
    COMMAND Python::Cython
      ${COMPILER_DIRECTIVES}
      ${INCLUDE_DIRECTORIES}
      ${CYTHON_CXX}
      ${embed-positions}
      ${line-directives}
      ${cleanup}
      ${syntax}
      ${embed}
      ${debug}
      --output-file ${output-file}
      $<TARGET_PROPERTY:${name},CYTHON_SOURCES>
    DEPENDS $<TARGET_PROPERTY:${name},CYTHON_SOURCES>
    COMMENT "Generating ${output-file} for '${name}'"
    OUTPUT ${output-file}
    COMMAND_EXPAND_LISTS
    VERBATIM)
  target_sources(${name} PRIVATE ${output-file})
endfunction()

#[[Hook for our target_sources override]]
function (target_sources_pyx target visibility)
  set(interface PUBLIC;INTERFACE)
  set(private PRIVATE;PUBLIC)
  if (visibility IN_LIST interface)
    set_property(TARGET ${target} APPEND
      PROPERTY
        INTERFACE_CYTHON_SOURCES "${ARGN}")
  endif()
  if (visibility IN_LIST private)
    set_property(TARGET ${target} APPEND
      PROPERTY
        CYTHON_SOURCES "${ARGN}")
  endif()
endfunction()
