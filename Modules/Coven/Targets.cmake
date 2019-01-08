include_guard(GLOBAL)

function (ixm_coven_add_executable)
endfunction()

function (ixm_coven_add_library)
endfunction()

function (ixm_coven_add_interface)
  if (EXISTS "${PROJECT_SOURCE_DIR}/src")
    return()
  endif()
  set(lib ${PROJECT_NAME})
  add_library(${lib} INTERFACE)
  add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${lib})
  target_include_directories(${lib}
    INTERFACE
      $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
      $<INSTALL_INTERFACE:include>)
endfunction()

function (ixm_coven_generate_targets)
endfunction()
