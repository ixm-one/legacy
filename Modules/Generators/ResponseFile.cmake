include_guard(GLOBAL)

import(IXM::Property::Generator::ResponseFile)

function(ixm_generate_response_file_expressions target)
  genex(INCLUDE_DIRECTORIES $<
      $<BOOL:$<TARGET_PROPERTY:${target},INCLUDE_DIRECTORIES>:
      -I
      $<JOIN:
        $<TARGET_PROPERTY:${target},INCLUDE_DIRECTORIES>,
        "\n-I"
      >
  >)

  genex(COMPILE_DEFINITIONS $<
      $<BOOL:$<TARGET_PROPERTY>:${target},COMPILE_DEFINITIONS>:
      -D
      $<JOIN:
        $<TARGET_PROPERTY:${target},COMPILE_DEFINITIONS>,
        "\n-D"
      >
  >)

  genex(COMPILE_OPTIONS $<
    $<BOOL:$<TARGET_PROPERTY:${target},COMPILE_OPTIONS>:
    $<JOIN:
      $<TARGET_PROPERTY:${target},COMPILE_OPTIONS>,
      "\n"
    >
  >)

  genex(COMPILE_FLAGS $<
    $<BOOL:$<TARGET_PROPERTY:${target},COMPILE_FLAGS>:
    $<JOIN:
      $<TARGET_PROPERTY:${target},COMPILE_FLAGS>,
      "\n"
    >
  >)

  genex(Default ${CMAKE_CXX_FLAGS})
  genex(Release $<$<CONFIG:Release>:${CMAKE_CXX_FLAGS_RELEASE}>)
  genex(Debug $<$<CONFIG:Debug>:${CMAKE_CXX_FLAGS_DEBUG}>)
  upvar(INCLUDE_DIRECTORIES COMPILE_DEFINITIONS COMPILE_OPTIONS COMPILE_FLAGS)
  upvar(Default Release Debug)
endfunction()

#[[

Given `target`, generate a response file that represents that targets compile
flags. If the target is an INTERFACE library, the INTERFACE_ properties will be
used.

Additional flags include:
 * LANGUAGE (C | CXX)

]]
function (ixm_generate_response_file target)
  parse(${ARGN} @ARGS=? LANGUAGE)
  get_property(rsp TARGET ${target} PROPERTY RESPONSE_FILE)
  if (NOT rsp)
    set(output "${CMAKE_CURRENT_BINARY_DIR}/IXM/${target}.rsp")
    set_target_properties(${target}
    PROPERTIES
      RESPONSE_FILE ${output})
  endif()
  ixm_generate_response_file_expressions(${target})
  string(JOIN "\n" content
    ${Default}
    ${Release}
    ${Debug}
    ${INCLUDE_DIRECTORIES}
    ${COMPILE_DEFINITIONS}
    ${COMPILE_OPTIONS}
    ${COMPILE_FLAGS})

  file(GENERATE
    OUTPUT $<TARGET_PROPERTY:${target},RESPONSE_FILE>
    CONTENT ${content})

endfunction()
