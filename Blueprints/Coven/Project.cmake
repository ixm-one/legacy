include_guard(GLOBAL)

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
  target_include_directories(${PROJECT_NAME}
    INTERFACE
      $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>)
  set_property(GLOBAL APPEND PROPERTY
    coven::${PROJECT_NAME}::install ${PROJECT_NAME})
endfunction()

function (coven_project_name)
  set(primary ${PROJECT_NAME}-library)
  if (NOT TARGET ${PROJECT_NAME}-library)
    set(primary ${PROJECT_NAME})
  endif()
  add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${primary})
endfunction()

function (coven_project_library)
  file(GLOB files
    LIST_DIRECTORIES OFF
    CONFIGURE_DEPENDS
    "${PROJECT_SOURCE_DIR}/src/*")
  list(FILTER files EXCLUDE REGEX "^${PROJECT_SOURCE_DIR}/src/main[.].*$")
  list(FILTER files EXCLUDE REGEX "^${PROJECT_SOURCE_DIR}/src/bin/.*$")
  if (NOT files)
    return()
  endif()
  # This needs to be a separate command...
  coven_library_create(name)
  target(SOURCES ${name} PRIVATE ${files})
endfunction()

#[[Generates object libraries]]
function (coven_project_objects)
  file(GLOB entries LIST_DIRECTORIES ON CONFIGURE_DEPENDS "${PROJECT_SOURCE_DIR}/src/*")
  foreach (entry IN LISTS entries)
    if (IS_DIRECTORY "${entry}")
      list(APPEND directories "${entry}")
    endif()
  endforeach()
  list(REMOVE_ITEM directories "${PROJECT_SOURCE_DIR}/src/bin")
  foreach (directory IN LISTS directories)
    file(GLOB sources CONFIGURE_DEPENDS "${directory}/*")
    # FIXME: Should we support main.<ext> as a "thing" for additional executables?
    list(FILTER sources EXCLUDE REGEX "^${directory}/main[.].*$")
    if (NOT sources)
      continue()
    endif()
    get_filename_component(name "${directory}" NAME)
    set(name ${PROJECT_NAME}-library-${name})
    add_library(${name} OBJECT)
    set_property(TARGET ${name} PROPERTY EXCLUDE_FROM_ALL ON)
    target(SOURCES ${name} PRIVATE ${sources})
    target_include_directories(${name}
      PUBLIC
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
      PRIVATE
        $<BUILD_INTERFACE:${directory})
    string(CONCAT when $<IF:
      $<BOOL:$<TARGET_PROPERTY:${name},WHEN>>,
      $<TARGET_GENEX_EVAL:
        ${name},
        $<TARGET_PROPERTY:${name},WHEN>
      >,
      $<BOOL:ON>
    >)
    if (NOT TARGET ${PROJECT_NAME}::library)
      coven_library_create(library)
    endif()
    target_sources(${library}
      PRIVATE
        $<${when}:$<TARGET_OBJECTS:${name}>>)
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
  set_property(GLOBAL APPEND PROPERTY coven::${PROJECT_NAME}::install ${name})
endfunction()

#[[Generates any additional 'runtime' targets located in src/bin]]
function (coven_project_runtime)
  file(GLOB files CONFIGURE_DEPENDS "${PROJECT_SOURCE_DIR}/src/bin/*")
  foreach (file IN LISTS files)
    get_filename_component(base "${file}" NAME_WE)
    set(name ${PROJECT_NAME}-program-${name})
    add_executable(${name})
    add_executable(${PROJECT_NAME}::program::${base} ALIAS ${name})
    target(SOURCES ${name} PRIVATE ${file})
    target_link_libraries(${name}
      PRIVATE
        $<TARGET_NAME_IF_EXISTS:${PROJECT_NAME}::library>
        ${PROJECT_NAME}::private)
    set_target_properties(${name}
      PROPERTIES
        OUTPUT_NAME ${base}
        EXPORT_NAME program::${base})
    set_property(GLOBAL APPEND PROPERTY coven::${PROJECT_NAME}::install ${name})
  endforeach()
endfunction()
