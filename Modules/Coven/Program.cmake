include_guard(GLOBAL)

function (ixm_coven_create_programs)
endfunction()

function (ixm_coven_find_main var path)
  foreach(ext IN LISTS IXM_SOURCE_EXTENSIONS)
    file(GLOB files
      LIST_DIRECTORIES OFF
      RELATIVE "${PROJECT_SOURCE_DIR}"
      CONFIGURE_DEPENDS "${PROJECT_SOURCE_DIR}/${path}/main.${ext}")
    list(APPEND sources ${files})
  endforeach()
  list(LENGTH sources length)
  if (NOT length)
    return()
  endif()
  if (length GREATER 1)
    error("${PROJECT_NAME} has more than one entry point in '${path}/'")
  endif()
  set(${var} ${sources} PARENT_SCOPE)
endfunction()

function (ixm_coven_create_primary_program)
  ixm_coven_find_main(source "src")
  if (NOT source)
    return()
  endif()
  add_executable(main ${source})
  add_executable(${PROJECT_NAME}::main ALIAS main)
    set_target_properties(main
      PROPERTIES OUTPUT_NAME ${PROJECT_NAME})
  target_link_libraries(main
    PRIVATE
      $<TARGET_NAME_IF_EXISTS:${PROJECT_NAME}::${PROJECT_NAME}>)
  target_include_directories(main PRIVATE "${PROJECT_SOURCE_DIR}/src")
  # install(TARGETS ${name} RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
endfunction()

function (ixm_coven_create_component_programs)
  file(GLOB entries LIST_DIRECTORIES ON
    RELATIVE ${PROJECT_SOURCE_DIR}
    "${PROJECT_SOURCE_DIR}/src/*")
  foreach (entry IN LISTS entries)
    if (IS_DIRECTORY "${PROJECT_SOURCE_DIR}/${entry}")
      list(APPEND components ${entry})
    endif()
  endforeach()
  foreach (component IN LISTS components)
    ixm_coven_find_main(source ${component})
    if (NOT source)
      continue()
    endif()
    get_filename_component(name ${component} NAME_WE)
    add_executable(${name})
    add_executable(${PROJECT_NAME}::component::${name} ALIAS ${name})
    target_include_directories(${name}
      PRIVATE
        "${PROJECT_SOURCE_DIR}/${component}")
    target_link_libraries(${name}
      PRIVATE
        $<TARGET_NAME_IF_EXISTS:${PROJECT_NAME}::${name}>)
  endforeach()
endfunction()

# TODO: Turn into component programs
function (ixm_coven_create_explicit_programs)
  foreach (ext IN LISTS IXM_SOURCE_EXTENSIONS)
    file(GLOB files
      LIST_DIRECTORIES OFF
      CONFIGURE_DEPENDS "${PROJECT_SOURCE_DIR}/src/bin/*.${ext}")
    list(APPEND sources ${files})
  endforeach()
  foreach (source IN LISTS sources)
    get_filename_component(name ${source} NAME_WE)
    add_executable(${name} ${source})
    add_executable(${PROJECT_NAME}::bin::${name} ALIAS ${name})
    target_link_libraries(${name}
      PRIVATE
        $<TARGET_NAME_IF_EXISTS:${PROJECT_NAME}::${PROJECT_NAME}>)
    # TODO: How to move this to the install section?
    install(TARGETS ${name} RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
  endforeach()
endfunction()

#function (ixm_layout_add_srcbin)
#  foreach (ext IN LISTS IXM_SOURCE_EXTENSIONS)
#    file(GLOB files
#      LIST_DIRECTORIES OFF
#      CONFIGURE_DEPENDS
#      "${PROJECT_SOURCE_DIR}/src/bin/*.${ext}")
#    list(APPEND sources ${files})
#  endforeach()
#  foreach (source IN LISTS sources)
#    ixm_layout_support_create(${source})
#    add_executable(${PROJECT_NAME}::${name} ALIAS ${target})
#    set_target_properties(${target} PROPERTIES OUTPUT_NAME ${name})
#  endforeach()
#endfunction()
#
#function (ixm_layout_add_srcdirs)
#  file(GLOB entries LIST_DIRECTORIES OFF "${PROJECT_SOURCE_DIR}/src/*")
#  list(REMOVE_ITEM entries "${PROJECT_SOURCE_DIR}/src/bin")
#  foreach (entry IN LISTS entries)
#    if (NOT IS_DIRECTORY ${entry})
#      continue()
#    endif()
#    ixm_layout_support_create(${entry})
#    add_executable(${PROJECT_NAME}::${name} ALIAS ${target})
#    set_target_properties(${target} PROPERTIES OUTPUT_NAME ${name})
#    foreach (ext IN LISTS IXM_SOURCE_EXTENSIONS)
#      target_glob_sources(${target} PRIVATE "${entry}/*.${ext}")
#    endforeach()
#  endforeach()
#endfunction()
