include_guard(GLOBAL)

# We override project so that we can
# 1) Let a user automatically set a project pre-determined layout as desired
# 2) Override cmake policies in subprojects if they chose to
# 3) Add a "project" scope to properties
# 4) Auto search for C and C++ tools if not already searched for
# 5) Only perform *some* of these steps if we are the root project :)
# 6) Automatically add a few paths to our module path
function (ixm_project_layout name)
  ixm_parse(${ARGN} @ARGS=? LAYOUT)
  ixm_upvar(REMAINDER)
  if (LAYOUT)
    set(IXM_CURRENT_LAYOUT_NAME ${LAYOUT} PARENT_SCOPE)
  endif()
endfunction()

function (ixm_project_load_layout name)
  set(IXM_CURRENT_LAYOUT_NAME ${name})
  if (EXISTS "${PROJECT_SOURCE_DIR}/config.cmake")
    include("${PROJECT_SOURCE_DIR}/config.cmake")
  endif()

  ixm_project_layout_discovery(${IXM_CURRENT_LAYOUT_NAME})
  get_property(IXM_CURRENT_LAYOUT_FILE GLOBAL PROPERTY IXM_CURRENT_LAYOUT_FILE)
  get_property(IXM_CURRENT_LAYOUT_NAME GLOBAL PROPERTY IXM_CURRENT_LAYOUT_NAME)
  # This is basically how we hack in a custom PROJECT scope for properties.
  # This is also, coincidentally, how _any_ layout can know if it's being
  # includeded via IXM. Just a TARGET named ixm::${PROJECT_NAME}::{lookups}
  # These are also "imported" and not marked as global so they aren't
  # accessible OUTSIDE of te project scope :)
  add_library(ixm::${name}::properties INTERFACE IMPORTED) # project specific properties
  add_library(ixm::${name}::commands INTERFACE IMPORTED)   # dynamic commands for invoke
  add_library(ixm::${name}::targets INTERFACE IMPORTED)    # info on various targets
  add_library(ixm::${name}::fetched INTERFACE IMPORTED)    # dependencies grabbed via Fetch
  set_target_properties(ixm::${name}::properties
    PROPERTIES
      INTERFACE_LAYOUT_FILE ${IXM_CURRENT_LAYOUT_FILE}
      INTERFACE_LAYOUT_NAME ${IXM_CURRENT_LAYOUT_NAME})
  set(IXM_CURRENT_LAYOUT_FILE ${IXM_CURRENT_LAYOUT_FILE} PARENT_SCOPE)
endfunction()

macro (project name)
  ixm_project_layout(${name} ${ARGN})
  _project(${name} ${REMAINDER})
  unset(REMAINDER)

  if (DEFINED IXM_CURRENT_LAYOUT_NAME)
    ixm_project_load_layout(${IXM_CURRENT_LAYOUT_NAME})
    include(${IXM_CURRENT_LAYOUT_FILE})
  endif()
endmacro()

function(ixm_target_compile_definitions target)
  ixm_alias_of(${target})
  target_compile_definitions(${target} ${ARGN})
endfunction()

function(ixm_target_compile_features target)
  ixm_alias_of(${target})
  target_compile_features(${target} ${ARGN})
endfunction()

function (ixm_target_compile_options target)
  ixm_alias_of(${target})
  target_compile_options(${target} ${ARGN})
endfunction()

function (ixm_target_include_directories target)
  ixm_alias_of(${target})
  target_include_directories(${target} ${ARGN})
endfunction()

function (ixm_target_link_directories target)
  ixm_alias_of(${target})
  target_link_directories(${target} ${ARGN})
endfunction()

function (ixm_target_link_libraries target)
  ixm_alias_of(${target})
  target_link_libraries(${target} ${ARGN})
endfunction()

function (ixm_target_link_options target)
  ixm_alias_of(${target})
  target_link_options(${target} ${ARGN})
endfunction()

function (ixm_target_sources target)
  ixm_parse(${ARGN}
    @FLAGS RECURSE
    @ARGS=* INTERFACE PUBLIC PRIVATE)
  set(glob GLOB)
  if (RECURSE)
    set(glob GLOB_RECURSE)
  endif()
  foreach (var IN ITEMS PRIVATE PUBLIC INTERFACE)
    if (NOT DEFINED ${var})
      continue()
    endif()
    foreach (entry IN LISTS ${var})
      string(FIND "${entry}" "*" glob)
      if (NOT glob EQUAL -1)
        file(${glob} entry CONFIGURE_DEPENDS ${entry})
      endif()
      list(APPEND sources ${entry})
    endforeach()
    if (COMMAND _target_sources)
      _target_sources(${target} ${var} ${sources})
    else()
      target_sources(${target} ${var} ${sources})
    endif()
  endforeach()
endfunction()

function (project_compile_definitions)
  target_compile_definitions(ixm::${PROJECT_NAME}::targets INTERFACE ${ARGN})
endfunction()

function (project_compile_features)
  target_compile_features(ixm::${PROJECT_NAME}::targets INTERFACE ${ARGN})
endfunction()

function (project_compile_options)
  target_compile_options(ixm::${PROJECT_NAME}::targets INTERFACE ${ARGN})
endfunction()

function (project_include_directories)
  target_include_directories(ixm::${PROJECT_NAME}::targets INTERFACE ${ARGN})
endfunction()

function (project_link_directories)
  target_link_directories(ixm::${PROJECT_NAME}::targets INTERFACE ${ARGN})
endfunction()

function (project_link_libraries)
  target_link_libraries(ixm::${PROJECT_NAME}::targets INTERFACE ${ARGN})
endfunction()

function (project_link_options)
  target_link_options(ixm::${PROJECT_NAME}::targets INTERFACE ${ARGN})
endfunction()


