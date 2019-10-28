include_guard(GLOBAL)

# TODO: Support languages and MSVC
# The following was sent to me from Robert Schumaker from MS regarding how cpprest
# generates a PCH
#[[
if(MSVC)
  get_target_property(_srcs cpprest SOURCES)

  if(NOT CMAKE_GENERATOR MATCHES "Visual Studio .*")
    set_property(SOURCE pch/stdafx.cpp APPEND PROPERTY OBJECT_OUTPUTS "${CMAKE_CURRENT_BINARY_DIR}/stdafx.pch")
    set_property(SOURCE ${_srcs} APPEND PROPERTY OBJECT_DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/stdafx.pch")
  endif()

  set_source_files_properties(pch/stdafx.cpp PROPERTIES COMPILE_FLAGS "/Ycstdafx.h")
  target_sources(cpprest PRIVATE pch/stdafx.cpp)
  target_compile_options(cpprest PRIVATE /Yustdafx.h)
endif()

]]
function (ixm_generate_precompiled_header target)
  parse(${ARGN} @ARGS=? LANGUAGE)
  assign(LANGUAGE ? LANGUAGE : CXX)

  get_property(pch TARGET ${target} PROPERTY PRECOMPILED_HEADER)
  if (NOT pch)
    return()
  endif()

  ixm_generate_response_file(${target} LANGUAGE ${LANGUAGE})
  ixm_generate_response_file(response-file ${target})
  set(non-msvc "$<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-x c++-header -o>")
  add_custom_command(
    OUTPUT $<TARGET_PROPERTY:${target},PRECOMPILED_HEADER>
    DEPENDS ${response-file}
    COMMAND "${CMAKE_CXX_COMPILER}"
      "@${response-file}"
      ${non-msvc}
      ${pch}
      $<TARGET_PROPERTY:${target},PRECOMPILED_HEADER_SOURCE>
    COMMENT "Generating '${pch}' for '${target}'"
    COMMAND_EXPAND_LISTS
    VERBATIM)
  target(SOURCES ${target}
    PRIVATE
      $<TARGET_PROPERTY:${target},PRECOMPILED_HEADER_SOURCE>)
  target_compile_options(${target}
    PRIVATE
      $<$<CXX_COMPILER_ID:MSVC>:/FI$<TARGET_PROPERTY:${target},PRECOMPILED_HEADER>>
      $<$<NOT:$<CXX_COMPILER_ID:MSVC>:-include $<TARGET_PROPERTY:${target},PRECOMPILED_HEADER>>
      $<$<NOT:$<CXX_COMPILER_ID:MSVC>:-Winvalid-pch>>)
endfunction()
