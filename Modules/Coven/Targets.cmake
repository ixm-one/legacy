include_guard(GLOBAL)

function (ixm_coven_add_library)
  set(lib ${PROJECT_NAME})
  foreach (ext IN LISTS IXM_SOURCE_EXTENSIONS)
    file(GLOB files LIST_DIRECTORIES OFF CONFIGURE_DEPENDS
      "${PROJECT_SOURCE_DIR}/src/*.${ext}")
    list(APPEND sources ${files})
  endforeach()
  list(REMOVE_ITEM sources ${main_files})
  if (NOT sources)
    return()
  endif()
  add_library(${lib})
  add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${lib})
  set_target_properties(${lib} PROPERTIES OUTPUT_NAME ${PROJECT_NAME})
  target_include_directories(${lib}
    PUBLIC
      $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
      $<INSTALL_INTERFACE:include>
    PRIVATE
      "${PROJECT_SOURCE_DIR}/src")
  target_sources(${lib} PRIVATE ${sources})
endfunction()

function (ixm_coven_add_interface)
  set(lib ${PROJECT_NAME})
  add_library(${lib} INTERFACE)
  add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${lib})
  target_include_directories(${lib}
    INTERFACE
      $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
      $<INSTALL_INTERFACE:include>)
endfunction()

function (ixm_coven_generate_primary_library)
  set(name ${PROJECT_NAME})
  if (EXISTS "${PROJECT_SOURCE_DIR}/src")
    ixm_coven_add_library()
  else()
    ixm_coven_add_interface()
  endif()
endfunction()

function (ixm_coven_generate_primary_program)
  set(name ${PROJECT_NAME}-program)
  foreach (ext IN LISTS IXM_SOURCE_EXTENSIONS)
    file(GLOB files LIST_DIRECTORIES OFF CONFIGURE_DEPENDS
      "${PROJECT_SOURCE_DIR}/src/main.${ext}")
    list(APPEND sources ${files})
  endforeach()
  list(LENGTH sources length)
  if (NOT length)
    return()
  endif()
  if (length GREATER 1)
    error("${PROJECT_NAME} has more than one entry point in 'src/'")
  endif()
  add_executable(${name})
  add_executable(${PROJECT_NAME}::Main ALIAS ${name})
  set_target_properties(${name}
    PROPERTIES OUTPUT_NAME ${PROJECT_NAME})
  target_link_libraries(${name}
    PRIVATE
      $<TARGET_NAME_IF_EXISTS:${PROJECT_NAME}::${PROJECT_NAME}>)
  target_include_directories(${name} PRIVATE "${PROJECT_SOURCE_DIR}/src")
  install(TARGETS ${name} RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
endfunction()

function (ixm_coven_generate_explicit_programs)
  foreach (ext IN LISTS IXM_SOURCE_EXTENSIONS)
    file(GLOB files LIST_DIRECTORIES OFF CONFIGURE_DEPENDS
      "${PROJECT_SOURCE_DIR}/src/bin/*.${ext}")
    list(APPEND sources ${files})
  endforeach()
  foreach (source IN LISTS sources)
    get_filename_component(name ${source} NAME_WE)
    add_executable(${name} ${source})
    add_executable(${PROJECT_NAME}::${name} ALIAS ${name})
    target_link_libraries(${name}
      PRIVATE
        $<TARGET_NAME_IF_EXISTS:${PROJECT_NAME}::${PROJECT_NAME}>)
    install(TARGETS ${name} RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
  endforeach()
endfunction()

#[[ Generate the primary project's targets ]]
function (ixm_coven_generate_targets)
  ixm_coven_generate_primary_library()
  ixm_coven_generate_primary_program()
  ixm_coven_generate_component_libraries()
  ixm_coven_generate_component_programs()
  ixm_coven_generate_explicit_programs()
endfunction()
