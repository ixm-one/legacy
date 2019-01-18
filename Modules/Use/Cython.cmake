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

function (ixm_cython_valid_state name)
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
This simply creates the cython library. It does not add sources. To add sources simply call `set_property(TARGET ${name} APPEND PROPERTY CYTHON_SOURCES sources...)

# TODO: Hack in support for custom property settings in our target_sources
# override
]]

function (add_cython_library name type)
  Python_add_library(${name} ${type})
  ixm_cython_validate_state(${name})
  set_property(TARGET ${name} PROPERTY CYTHON_LINE_DIRECTIVES ON)

  get_property(language TARGET PROPERTY CYTHON_OUTPUT_LANGUAGE)
  string(TOLOWER ${language} extension)

  genex(INCLUDE_DIRECTORIES $<
    $<BOOL:$<TARGET_PROPERTY:${name},INCLUDE_DIRECTORIES>>:
    -I
    $<JOIN:
        $<TARGET_PROPERTY:${name},INCLUDE_DIRECTORIES>,
        $<SEMICOLON>-I
    >
  >)

  genex(COMPILER_DIRECTIVES $<
    $<BOOL:$<TARGET_PROPERTY:${name},CYTHON_COMPILER_DIRECTIVES>>:
    -X$<JOIN:
        $<TARGET_PROPERTY:${name},CYTHON_COMPILER_DIRECTIVES>,
        $<SEMICOLON>-X
      >
  >)
  genex(CYTHON_CXX $<
    $<STREQUAL:$<TARGET_PROPERTY:CYTHON_OUTPUT_LANGUAGE>,CXX>:--cplus
  >)

  genex(embed-positions $<$<CONFIG:Debug>:--embed-positions>)
  genex(language $<$<BOOL:$<CXX_COMPILER_ID>:--cplus>)
  genex(syntax $<$<BOOL:${Python_VERSION_MAJOR}>:-${Python_VERSION_MAJOR}>)
  genex(embed $<
    $<STREQUAL:$<TARGET_PROPERTY:${name},TYPE>,EXECUTABLE>:--embed
    $<
      $<BOOL:$<TARGET_PROPERTY:${name},CYTHON_ENTRYPOINT>>:
      =$<TARGET_PROPERTY:${name},CYTHON_ENTRYPOINT>
    >
  >)
  genex(cleanup $<
    $<BOOL:$<TARGET_PROPERTY:${name},CYTHON_CLEANUP_LEVEL>:
    --cleanup $<TARGET_PROPERTY:${name},CYTHON_CLEANUP_LEVEL>
  >)
  genex(debug $<$<CONFIG:Debug>:--gdb>)
  genex(line-directives $<
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
