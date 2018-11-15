include_guard(GLOBAL)

#[[ Attempts to create the primary executable for a project. No-op otherwise ]]
function (ixm_layout_add_program)
  set(exe ${PROJECT_NAME}-program)
  foreach (ext IN LISTS IXM_SOURCE_EXTENSIONS)
    if (EXISTS "${PROJECT_SOURCE_DIR}/src/main.${ext}")
      add_executable(${exe} "${PROJECT_SOURCE_DIR}/src/main.${ext}")
      add_executable(${PROJECT_NAME}::Main ALIAS ${exe})
      set_target_properties(${exe}
        PROPERTIES OUTPUT_NAME ${PROJECT_NAME})
      target_link_libraries(${exe} PRIVATE
        $<TARGET_NAME_IF_EXISTS:${PROJECT_NAME}-library>)
      target_include_directories(${exe} PRIVATE "${PROJECT_SOURCE_DIR}/src")
      return()
    endif()
  endforeach()
endfunction()

#[[ Attempts to create the primary library for a project ]]
function (ixm_layout_add_library)
  set(lib ${PROJECT_NAME}-library)
  foreach (ext IN LISTS IXM_SOURCE_EXTENSIONS)
    file(GLOB files
      LIST_DIRECTORIES OFF
      CONFIGURE_DEPENDS
      "${PROJECT_SOURCE_DIR}/src/*.${ext}")
    list(REMOVE_ITEM files "${PROJECT_SOURCE_DIR}/src/main.${ext}")
    list(APPEND sources ${files})
  endforeach()
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
    PRIVATE "${PROJECT_SOURCE_DIR}/src")
  target_sources(${lib} PRIVATE ${sources})
endfunction()

function (ixm_layout_add_interface)
  set(lib ${PROJECT_NAME}-library)
  add_library(${lib} INTERFACE)
  add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${lib})
  target_include_directories(${lib}
    INTERFACE
      $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
      $<INSTALL_INTERFACE:include>)
endfunction()
