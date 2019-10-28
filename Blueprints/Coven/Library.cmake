include_guard(GLOBAL)

function (coven_library_create output)
  set(name ${PROJECT_NAME}-library)
  add_library(${name})
  add_library(${PROJECT_NAME}::library ALIAS ${name})
  target_link_libraries(${name}
    PUBLIC
      ${PROJECT_NAME}::interface
    PRIVATE
      ${PROJECT_NAME}::private)
  set_target_properties(${name}
    PROPERTIES
      OUTPUT_NAME ${PROJECT_NAME}
      EXPORT_NAME ${PROJECT_NAME})
  set(${output} ${name} PARENT_SCOPE)
endfunction()

# TODO: move this to target as target(MSVC) subcommand?
function (coven_library_msvc_runtime target)
  set(msvc-rt $<TARGET_PROPERTY:MSVC_RUNTIME_LIBRARY>)
  string(CONCAT should-backport $<AND:
    $<OR:
      $<BOOL:${MSVC}>,
      $<STREQUAL:${CMAKE_CXX_SIMULATE_ID},MSVC>
    >,
    $<VERSION_LESS:${CMAKE_VERSION},3.15>
  >)
  string(CONCAT static-debug $<
    $<AND:
      ${should-backport},
      $<STREQUAL:${msvc-rt},MultiThreadedDebug>
    >:-MTd
  >)
  string(CONCAT shared-debug $<
    $<AND:
      ${should-backport},
      $<STREQUAL:${msvc-rt},MultiThreadedDebugDLL>
    >:-MDd
  >)
  string(CONCAT static $<
    $<AND:
      ${should-backport},
      $<STREQUAL:${msvc-rt},MultiThreaded>
    >:-MT
  >)
  string(CONCAT shared $<
    $<AND:
      ${should-backport},
      $<STREQUAL:${msvc-rt},MultiThreadedDLL>
    >:-MD
  >)
  list(APPEND msvc-runtime ${static-debug})
  list(APPEND msvc-runtime ${shared-debug})
  list(APPEND msvc-runtime ${static})
  list(APPEND msvc-runtime ${shared})
  target_compile_options(${target} PRIVATE ${msvc-runtime})
endfunction()
