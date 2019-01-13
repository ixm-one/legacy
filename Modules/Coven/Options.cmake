include_guard(GLOBAL)

function (ixm_coven_create_options)
  option(${PROJECT_NAME}_BUILD_EXAMPLES "Build examples for '${PROJECT_NAME}'" ON)
  option(${PROJECT_NAME}_BUILD_BENCH "Build benchmarks for '${PROJECT_NAME}'" ON)
  option(${PROJECT_NAME}_BUILD_TESTS "Build tests for '${PROJECT_NAME}'" ON)
  option(${PROJECT_NAME}_BUILD_DOCS "Build docs for '${PROJECT_NAME}'" ON)
endfunction()
