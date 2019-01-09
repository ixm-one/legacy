include_guard(GLOBAL)

function (ixm_brujeria_generate_module)
  add_library(${PROJECT_NAME} MODULE)
  file(GLOB_RECURSE sources
    LIST_DIRECTORIES OFF
    CONFIGURE_DEPENDS "${PROJECT_SOURCE_DIR}/src/*")
  target_sources(${PROJECT_NAME} PRIVATE ${sources})
  target_include_directories(${PROJECT_NAME} PRIVATE "${PROJECT_SOURCE_DIR}/include")
endfunction()
