include_guard(GLOBAL)

import(IXM::Property::Generator::ResponseFile)

function(ixm_generate_response_file_cache target)
  set(INCLUDE_DIRECTORIES $<TARGET_PROPERTY:${target},INCLUDE_DIRECTORIES>)
  set(COMPILE_DEFINITIONS $<TARGET_PROPERTY:${target},COMPILE_DEFINITIONS>)
  set(COMPILE_OPTIONS $<TARGET_PROPERTY:${target},COMPILE_OPTIONS>)
  set(COMPILE_FLAGS $<TARGET_PROPERTY:${target},COMPILE_FLAGS>)
  set(LINK_DIRECTORIES $<TARGET_PROPERTY:${target},LINK_DIRECTORIES>)
  set(LINK_LIBRARIES $<TARGET_PROPERTY:${target},LINK_LIBRARIES>)
  set(LINK_OPTIONS $<TARGET_PROPERTY:${target},LINK_OPTIONS>)

  set(${PROJECT_NAME}_${target}_GENEX_INCLUDE_DIRECTORIES
    "$<$<BOOL:${INCLUDE_DIRECTORIES}>,-I$<JOIN:${INCLUDE_DIRECTORIES},\n-I>>"
    CACHE INTERNAL "")
  set(${PROJECT_NAME}_${target}_GENEX_COMPILE_DEFINITIONS
    "$<$<BOOL:${COMPILE_DEFINITIONS}>,-D$<JOIN:${COMPILE_DEFINITIONS},\n-D>>"
    CACHE INTERNAL "")
  set(${PROJECT_NAME}_${target}_GENEX_COMPILE_OPTIONS
    "$<$<BOOL:${COMPILE_OPTIONS}>,$<JOIN:${COMPILE_OPTIONS},\n>>"
    CACHE INTERNAL "")
  set(${PROJECT_NAME}_${target}_GENEX_COMPILE_FLAGS
    "$<$<BOOL:${COMPILE_FLAGS}>,$<JOIN:${COMPILE_FLAGS},\n>>"
    CACHE INTERNAL "")
endfunction()

#[[

Given `target`, generate a response file that represents that targets compile
flags. If the target is an INTERFACE library, the INTERFACE_ properties will be
used.

Additional flags include:
 * LANGUAGE (C | CXX)

]]
function (ixm_generate_response_file target)
  ixm_parse(${ARGN} @ARGS=? LANGUAGE)
  get_property(rsp TARGET ${target} PROPERTY RESPONSE_FILE)
  if (rsp)
    return()
  endif()
  set(path "${PROJECT_BINARY_DIR}/IXM/generators/response-file")
  set(output "${path}/${target}.rsp")
  if (NOT ${PROJECT_NAME}_${target}_GENEX_INCLUDE_DIRECTORIES)
    ixm_generate_response_file_cache(${target})
  endif()
  string(JOIN "\n" content
    ${CMAKE_CXX_FLAGS}
    ${CMAKE_CXX_FLAGS_${BUILD_TYPE}}
    ${${PROJECT_NAME}_${target}_GENEX_INCLUDE_DIRECTORIES}
    ${${PROJECT_NAME}_${target}_GENEX_COMPILE_DEFINITIONS}
    ${${PROJECT_NAME}_${target}_GENEX_COMPILE_OPTIONS}
    ${${PROJECT_NAME}_${target}_GENEX_COMPILE_FLAGS})
  file(GENERATE OUTPUT ${output} CONTENT ${content})
  set_target_properties(${target}
    PROPERTIES
      RESPONSE_FILE ${output})
endfunction()
