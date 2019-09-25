include_guard(GLOBAL)

function (coven_common_check_main out-var directory)
  get_property(extensions GLOBAL PROPERTY ixm::extensions::source)
  foreach (extension IN LISTS extensions)
    if (EXISTS "${directory}/main.${extension}")
      set(${out-var} ON PARENT_SCOPE)
      return()
    endif()
  endforeach()
endfunction()

function (coven_common_create_test component item)
  get_filename_component(name "${item}" NAME_WE)
  string(REPLACE " " "-" name "${name}")
  set(target "${PROJECT_NAME}-${component}-${name}")
  set(alias "${PROJECT_NAME}::${component}::${name}")
  add_executable(${target} ${ARGN})
  add_test(${alias} ALIAS ${target})
  target_link_libraries(${target}
    PRIVATE
      $<TARGET_NAME_IF_EXISTS:${PROJECT_NAME}::${PROJECT_NAME}>
      $<TARGET_NAME_IF_EXISTS:${PROJECT_NAME}::${component}>)
  set(target "${target}" PARENT_SCOPE)
endfunction()
