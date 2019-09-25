include_guard(GLOBAL)

function (coven_tests_init)
  string(MAKE_C_IDENTIFIER "${PROJECT_NAME}" project)
  string(TOUPPER "${project}" project)
  if (NOT ${project}_BUILD_TESTS)
    return()
  endif()
  file(GLOB items
    LIST_DIRECTORIES ON
    CONFIGURE_DEPENDS
    "${PROJECT_SOURCE_DIR}/tests/*")
  foreach (item IN LISTS items)
    if (IS_DIRECTORY "${item}")
      file(GLOB files CONFIGURE_DEPENDS "${item}/*")
      if (NOT files)
        continue()
      endif()
    else()
      set(files "${item}")
    endif()
    coven_common_create_test(test "${item}" ${files})
    set_property(TARGET ${target} PROPERTY
      RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/tests)
  endforeach()
endfunction()
