include_guard(GLOBAL)

# TODO: Support languages and MSVC
function (ixm_generate_precompiled_header target)
  parse(${ARGN} @ARGS=? LANGUAGE)
  var(LANGUAGE LANGUAGE CXX)

  ixm_generate_response_file(${target} LANGUAGE ${LANGUAGE})
  ixm_generate_response_file(response-file ${target})

  get_property(pch TARGET ${target} PROPERTY PRECOMPILED_HEADER)

  genexp(non-msvc $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-x c++-header -o>)

  add_custom_command(
    OUTPUT ${pch}
    DEPENDS ${response-file}
    COMMAND "${CMAKE_CXX_COMPILER}"
      "@${response-file}"
      ${non-msvc}
      ${pch}
      $<TARGET_PROPERTY:${target},PRECOMPILED_HEADER_SOURCE>
    COMMENT "Generating '${pch}' for '${target}'"
    COMMAND_EXPAND_LISTS
    VERBATIM)
  target_sources(${target}
    PRIVATE
      $<TARGET_PROPERTY:${target},PRECOMPILED_HEADER_SOURCE>)
  target_compile_options(${target}
    PRIVATE
      $<$<NOT:$<CXX_COMPILER_ID:MSVC>:-Winvalid-pch>>)
endfunction()
