include_guard(GLOBAL)

foreach (ext IN LISTS CMAKE_CXX_SOURCE_FILE_EXTENSIONS
                      CMAKE_C_SOURCE_FILE_EXTENSIONS)
  file(GLOB test-files CONFIGURE_DEPENDS ${PROJECT_SOURCE_DIR}/tests/*.${ext})
  foreach (file IN LISTS test-files)
    list(APPEND tests ${file})
  endforeach()
endforeach ()

foreach (src IN LISTS tests)
  get_filename_component(${src} test NAME_WE)
  add_executable(${test} ${src})
  add_test(test-${test} ${test})
endforeach()
