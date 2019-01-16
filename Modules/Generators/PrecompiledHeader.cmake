include_guard(GLOBAL)

function (ixm_generate_precompiled_header target)
  ixm_generate_reponse_file(${target})
  get_property(pch TARGET PROPERTY PRECOMPILED_HEADER)

  add_custom_command(
    OUTPUT ${pch}
    DEPENDS $<TARGET_PROPERTY:${target},RESPONSE_FILE>
    COMMAND "${CMAKE_CXX_COMPILER}"
      "@$<TARGET_PROPERTY:${target},RESPONSE_FILE>"
      $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-x>
      $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:c++-header>
      $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-o>
      ${pch}
      $<TARGET_PROPERTY:${target},PRECOMPILED_HEADER_SOURCE>
    COMMAND_EXPAND_LISTS
    VERBATIM)
endfunction()
