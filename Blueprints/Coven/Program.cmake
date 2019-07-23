include_guard(GLOBAL)

function (coven_program_init)
  coven_program_create_bin_targets()
endfunction ()

function (coven_program_create_bin_targets)
  if (NOT IS_DIRECTORY "${PROJECT_SOURCE_DIR}/src/bin")
    return()
  endif()
  file(GLOB files CONFIGURE_DEPENDS "${PROJECT_SOURCE_DIR}/src/bin/*")
  foreach (file IN LISTS files)
    get_filename_component(name "${file}" NAME_WE)
    executable(${PROJECT_NAME}-bin-${name} ${file})
    target_link_libraries(${PROJECT_NAME}-bin-${name} PRIVATE
      $<TARGET_NAME_IF_EXISTS:${PROJECT_NAME}::${PROJECT_NAME}>)
  endforeach()
endfunction()
