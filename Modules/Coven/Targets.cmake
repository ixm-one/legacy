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

function (ixm_coven_generate_primary_library)
  set(name ${PROJECT_NAME})
  if (EXISTS "${PROJECT_SOURCE_DIR}/src")
    ixm_coven_add_library()
  else()
    ixm_coven_add_interface()
  endif()
endfunction()
