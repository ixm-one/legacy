include_guard(GLOBAL)

function (ixm_coven_add_executable)
  set(exe ${PROJECT_NAME}-main)
  foreach (ext IN LISTS IXM_SOURCE_EXTENSIONS)
    if (NOT EXISTS "${PROJECT_SOURCE_DIR}/src/main.${ext}")
      continue()
    endif()
    add_executable(${exe} "${PROJECT_SOURCE_DIR}/src/main.${ext}")
    add_executable(${PROJECT_NAME}::Main ALIAS ${exe})
    set_target_properties(${exe}
      PROPERTIES OUTPUT_NAME ${PROJECT_NAME})
    target_link_libraries(${exe}
      PRIVATE
        $<TARGET_NAME_IF_EXISTS:${PROJECT_NAME}-library>)
    target_include_directories(${exe} PRIVATE "${PROJECT_SOURCE_DIR}/src")
    return()
  endforeach()
endfunction()

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
  if (EXISTS "${PROJECT_SOURCE_DIR}/src")
    return()
  endif()
  set(lib ${PROJECT_NAME})
  add_library(${lib} INTERFACE)
  add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${lib})
  target_include_directories(${lib}
    INTERFACE
      $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
      $<INSTALL_INTERFACE:include>)
endfunction()

function (ixm_coven_generate_targets)
endfunction()
