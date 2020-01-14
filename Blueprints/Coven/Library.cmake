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
endfunction ()

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
