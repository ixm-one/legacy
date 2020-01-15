include_guard(GLOBAL)

# TODO: Rename this file to Targets.cmake, as it better fits what this file
# actually does :)

function (coven_project_init)
  coven_project_interface() # Generates 'PROJECT_NAME::interface'
  coven_project_library() # Generates 'PROJECT_NAME::library'
  coven_project_objects() # Generates object libraries per each directory.
  coven_project_program() # Generates 'PROJECT_NAME::program' target
  coven_project_runtime() # Generates 'PROJECT_NAME::program::<name>' targets
  coven_project_name() # Generates the correct PROJECT_NAME::PROJECT_NAME
endfunction()

function (coven_project_interface)
  add_library(${PROJECT_NAME}::private INTERFACE IMPORTED)
  add_library(${PROJECT_NAME} INTERFACE)

  add_library(${PROJECT_NAME}::interface ALIAS ${PROJECT_NAME})
  set_property(TARGET ${PROJECT_NAME} PROPERTY EXPORT_NAME interface)

  target_include_directories(${PROJECT_NAME}
    INTERFACE
      $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
      $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)
endfunction()

function (coven_project_library)
  file(GLOB_RECURSE files CONFIGURE_DEPENDS "${PROJECT_SOURCE_DIR}/src/*")
  list(FILTER files EXCLUDE REGEX "^${PROJECT_SOURCE_DIR}/src/main[.].*$")
  list(FILTER files EXCLUDE REGEX "^${PROJECT_SOURCE_DIR}/src/bin/.*$")
  if (NOT files)
    return()
  endif()
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
endfunction()

#[[Generates object libraries]]
function (coven_project_objects)
  file(GLOB entries CONFIGURE_DEPENDS "${PROJECT_SOURCE_DIR}/src/*")
  foreach (entry IN LISTS entries)
    if (IS_DIRECTORY "${entry}")
      list(APPEND directories "${entry}")
    endif()
  endforeach()
  list(REMOVE_ITEM directories "${PROJECT_SOURCE_DIR}/src/bin")
  list(APPEND directories "${PROJECT_SOURCE_DIR}/src")
  foreach (directory IN LISTS directories)
    coven_project_module(${directory})
  endforeach()
endfunction()

#[[Generates the 'main' program of the project]]
function (coven_project_program)
  file(GLOB files CONFIGURE_DEPENDS "${PROJECT_SOURCE_DIR}/src/main.*")
  if (NOT files)
    return()
  endif()
  set(name ${PROJECT_NAME}-program)
  add_executable(${name})
  add_executable(${PROJECT_NAME}::program ALIAS ${name})
  target(SOURCES ${name} PRIVATE ${files})
  target_link_libraries(${name}
    PRIVATE
      $<TARGET_NAME_IF_EXISTS:${PROJECT_NAME}::library>
      ${PROJECT_NAME}::private)
  set_target_properties(${name}
    PROPERTIES
      OUTPUT_NAME ${PROJECT_NAME}
      EXPORT_NAME ${PROJECT_NAME})
endfunction()

#[[Generates any additional 'runtime' targets located in src/bin]]
function (coven_project_runtime)
  file(GLOB entries CONFIGURE_DEPENDS "${PROJECT_SOURCE_DIR}/src/bin/*")
  foreach (entry IN LISTS entries)
    if (IS_DIRECTORY "${entry}")
      get_filename_component(name "${entry}" NAME)
      list(GLOB_RECURSE files CONFIGURE_DEPENDS "${entry}/*")
    else()
      get_filename_component(name "${entry}" NAME_WE)
      set(files ${entry})
    endif()
    set(target ${PROJECT_NAME}-program-${name})
    add_executable(${target})
    add_executable(${PROJECT_NAME}::program::${name} ALIAS ${target})
    target(SOURCES ${target} PRIVATE ${files})
    target_link_libraries(${target}
      PRIVATE
        $<TARGET_NAME_IF_EXISTS:${PROJECT_NAME}::library>
        ${PROJECT_NAME}::private)
    set_target_properties(${target}
      PROPERTIES
        EXPORT_NAME program::${name}
        OUTPUT_NAME ${name})
  endforeach()
endfunction()

function (coven_project_name)
  set(primary ${PROJECT_NAME}-library)
  if (NOT TARGET ${PROJECT_NAME}-library)
    set(primary ${PROJECT_NAME})
  endif()
  add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${primary})
endfunction()

#[[Generates a single object library (NOT a C++ module NOR a CMake Module]]
function (coven_project_module directory)
  file(GLOB sources LIST_DIRECTORIES OFF CONFIGURE_DEPENDS "${directory}/*")
  # FIXME: Rust currently supports turning directories with a main file into a
  # full executable. We should do this too before the blueprint is considered
  # stable
  list(FILTER sources EXCLUDE REGEX "^${directory}/main[.].*$")
  if (NOT sources)
    return()
  endif()
  get_filename_component(name "${directory}" NAME)
  set(library ${PROJECT_NAME}-library-${name})
  add_library(${library} OBJECT)
  add_library(${PROJECT_NAME}::library::${name} ALIAS ${library})
  set_property(TARGET ${library} PROPERTY EXCLUDE_FROM_ALL ON)
  target(SOURCES ${library} PRIVATE ${sources})
  target_include_directories(${library}
    PUBLIC
      $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
    PRIVATE
      $<BUILD_INTERFACE:${directory}>)
  set(property $<TARGET_PROPERTY:${library},WHEN>)
  string(CONCAT when $<IF:
    $<BOOL:${property}>,
    $<TARGET_GENEX_EVAL:${library},${property}>,
    $<BOOL:ON>
  >)
  target_sources(${PROJECT_NAME}-library PRIVATE $<${when}:$<TARGET_OBJECTS:${library}>>)
endfunction()


