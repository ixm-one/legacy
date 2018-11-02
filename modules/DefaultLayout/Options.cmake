include_guard(GLOBAL)

# TODO: Make BUILD_TESTING/BUILD_SHARED dependent on global ones
function (__default_options)
  option(${PROJECT_NAME}_BUILD_BENCHMARKS "Build benchmarks for ${PROJECT_NAME}")
  option(${PROJECT_NAME}_BUILD_EXAMPLES "Build examples for ${PROJECT_NAME}")
  option(${PROJECT_NAME}_BUILD_TESTING "Build tests for ${PROJECT_NAME}")
  option(${PROJECT_NAME}_BUILD_DOCS "Build docs for ${PROJECT_NAME}")
  option(${PROJECT_NAME}_QUIET "Suppress output for ${PROJECT_NAME}")
endfunction()
