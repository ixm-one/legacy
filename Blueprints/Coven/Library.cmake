include_guard(GLOBAL)

function (coven_library_init)
  coven_library_create_library_target()
  coven_library_create_object_targets()

  coven_library_create_include_target()
  add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})
endfunction ()

function (coven_library_create_library_target)
  if (NOT IS_DIRECTORY "${PROJECT_SOURCE_DIR}/src")
    return()
  endif()
  coven_library_msvc_runtime(msvc-runtime)
  file(GLOB files
    LIST_DIRECTORIES OFF
    CONFIGURE_DEPENDS
    "${PROJECT_SOURCE_DIR}/src/*")
  list(FILTER files EXCLUDE REGEX "${PROJECT_SOURCE_DIR}/src/main[.].*$")
  list(FILTER files EXCLUDE REGEX "${PROJECT_SOURCE_DIR}/src/bin$")
  if (NOT files)
    return()
  endif()
  if (NOT sources)
    return()
  endif()
  if (NOT TARGET ${PROJECT_NAME})
    add_library(${PROJECT_NAME})
  endif()
  target_sources(${PROJECT_NAME} PRIVATE ${sources})
  target_include_directories(${PROJECT_NAME}
    PUBLIC
      $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
      $<INSTALL_INTERFACE:include>)
  target_compile_options(${PROJECT_NAME} PRIVATE ${msvc-runtime})
endfunction()

function (coven_library_create_include_target)
  if (NOT TARGET ${PROJECT_NAME})
    add_library(${PROJECT_NAME} INTERFACE)
    target_include_directories(${PROJECT_NAME}
      INTERFACE
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)
  endif()
endfunction()

function (coven_library_create_object_targets)
  file(GLOB entries LIST_DIRECTORIES ON CONFIGURE_DEPENDS "${PROJECT_SOURCE_DIR}/src/*")
  foreach (entry IN LISTS entries)
    if (NOT IS_DIRECTORY "${entry}")
      continue()
    endif()
    list(APPEND directories "${entry}")
  endforeach()
  foreach (directory IN LISTS directories)
    file(GLOB sources CONFIGURE_DEPENDS "${directory}/*")
    if (NOT sources)
      continue()
    endif()
    get_filename_component(name "${directory}" NAME)
    add_library(${PROJECT_NAME}-${name} OBJECT)
    target_sources(${PROJECT_NAME}-${name} PRIVATE ${sources})
    target_include_directories(${PROJECT_NAME}-${name}
      PRIVATE
        $<BUILD_INTERFACE:${directory}>)
    if (NOT TARGET ${PROJECT_NAME})
      add_library(${PROJECT_NAME})
    endif()
    target_sources(${PROJECT_NAME} PRIVATE $<TARGET_OBJECTS:${PROJECT_NAME}-${name}>)
  endforeach()
endfunction()

function (coven_library_msvc_runtime output)
  genexp(msvc-runtime-static-debug $<
    $<AND:
      $<BOOL:${MSVC}>,
      $<VERSION_LESS:${CMAKE_VERSION},3.15>,
      $<STREQUAL:$<TARGET_PROPERTY:MSVC_RUNTIME_LIBRARY>,MultiThreadedDebug>
    >:-MTd
  >)
  genexp(msvc-runtime-shared-debug $<
    $<AND:
      $<BOOL:${MSVC}>,
      $<VERSION_LESS:${CMAKE_VERSION},3.15>,
      $<STREQUAL:$<TARGET_PROPERTY:MSVC_RUNTIME_LIBRARY>,MultiThreadedDebugDLL>
    >:-MDd
  >)
  genexp(msvc-runtime-static $<
    $<AND:
      $<BOOL:${MSVC}>,
      $<VERSION_LESS:${CMAKE_VERSION},3.15>,
      $<STREQUAL:$<TARGET_PROPERTY:MSVC_RUNTIME_LIBRARY>,MultiThreaded>
      >:-MT
  >)
  genexp(msvc-runtime-shared $<
    $<AND:
      $<BOOL:${MSVC}>,
      $<VERSION_LESS:${CMAKE_VERSION},3.15>,
      $<STREQUAL:$<TARGET_PROPERTY:MSVC_RUNTIME_LIBRARY>,MultiThreadedDLL>
      >:-MD
  >)
  list(APPEND msvc-runtime ${msvc-runtime-static-debug})
  list(APPEND msvc-runtime ${msvc-runtime-shared-debug})
  list(APPEND msvc-runtime ${msvc-runtime-static})
  list(APPEND msvc-runtime ${msvc-runtime-shared})
  set(${output} ${msvc-runtime} PARENT_SCOPE)
endfunction()
