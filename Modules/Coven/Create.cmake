include_guard(GLOBAL)

function (cvn_create_options)
  set(options BENCHMARKS EXAMPLES TESTS DOCS)
  foreach (option IN ITEMS BENCHMARKS EXAMPLES TESTS DOCS)
    string(TOLOWER "${option}" lower)
    if (${PROJECT_NAME}_STANDALONE)
      option(BUILD_${option} "Build ${lower}" ON)
    endif()
    set(name ${PROJECT_NAME}_BUILD_${option})
    set(docs "Build ${lower} for ${PROJECT_NAME}")
    set(initial OFF)
    if (BUILD_${option} OR ${PROJECT_NAME}_STANDALONE)
      set(initial ON)
    endif()
    option(${name} "${docs}" ${initial})
  endforeach()
endfunction()

function (cvn_create_library)
  cvn_library_primary()
  if (NOT TARGET ${PROJECT_NAME})
    add_library(${PROJECT_NAME} INTERFACE)
    target_include_directories(${PROJECT_NAME}
      INTERFACE
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)
  endif()
  add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})
endfunction()

function (cvn_create_component component)
  string(TOUPPER "${component}" option)
  if (NOT BUILD_${option})
    return()
  endif()
  glob(items "${PROJECT_SOURCE_DIR}/${component}/*")
  foreach (item IN LISTS items)
    if (IS_DIRECTORY "${item}")
      glob(files FILES_ONLY "${item}/*")
      if (NOT files)
        continue()
      endif()
    else()
      list(APPEND files "${item}")
    endif()
    get_filename_component(name "${item}" NAME_WE)
    string(REPLACE " " "-" name "${name}")
    set(target ${PROJECT_NAME}-${component-${name})
    set(alias ${PROJECT_NAME}::${component}::${name})
    add_executable(${target} ${files})
    add_executable(${alias} ALIAS ${target})
    add_test(${alias} ${target})
    target_link_libraries(${target}
      PRIVATE
        $<TARGET_NAME_IF_EXISTS:${PROJECT_NAME}::${PROJECT_NAME}>)
    set_property(TARGET ${target} PROPERTY
      RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${component})
  endforeach()
endfunction()

# TODO: This needs to run at exit scope...
function (cvn_create_install)
  install(TARGETS ${PROJECT_NAME}
    EXPORT ${PROJECT_NAME}-targets
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin)
  install(EXPORT ${PROJECT_NAME}-targets
    DESTINATION ${CMAKE_INSTALL_DATADIR}/${PROJECT_NAME})
endfunction()
