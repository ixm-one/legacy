include_guard(GLOBAL)

function (ixm_coven_create_benchmarks)
  file(GLOB entries
    LIST_DIRECTORIES ON
    CONFIGURE_DEPENDS "${PROJECT_SOURCE_DIR}/bench/*")
  foreach (entry IN LISTS entries)
    get_filename_component(name ${entry} NAME_WE)
    if (IS_DIRECTORY ${entry})
      list(APPEND directories ${entry})
    endif()
  endforeach()
  foreach (ext IN LISTS IXM_SOURCE_EXTENSIONS)
    file(GLOB files
      LIST_DIRECTORIES OFF
      CONFIGURE_DEPENDS "${PROJECT_SOURCE_DIR}/bench/*.${ext}")
    list(APPEND sources ${files})
  endforeach()
  foreach (source IN LISTS sources)
    get_filename_component(name ${source} NAME_WE)
    set(name ${PROJECT_NAME}-${name})
    set(target bench-${name})
    add_executable(${target} ${source})
    target_link_libraries(${target}
      PRIVATE
        $<TARGET_NAME_IF_EXISTS:${PROJECT_NAME}::${PROJECT_NAME}>)
    add_test(${name} bench-${name})
  endforeach()
  foreach (directory IN LISTS directories)
    get_filename_component(name ${directory} NAME_WE)
    set(name ${PROJECT_NAME}-${name})
    set(target bench-${name})
    add_executable(${target})
    target_link_libraries(${target}
      PRIVATE
        $<TARGET_NAME_IF_EXISTS:${PROJECT_NAME}::${PROJECT_NAME}>)
  endforeach()
endfunction()
