include_guard(GLOBAL)

function (ixm_project_version name)
  if (DEFINED PROJECT_VERSION)
    return()
  endif()
  set(VERSION 0.1.0)
  set(MAJOR 0)
  set(MINOR 1)
  set(PATCH 0)
  set(TWEAK)
  set(${name}_VERSION ${VERSION} PARENT_SCOPE)
  set(PROJECT_VERSION ${VERSION} PARENT_SCOPE)
  foreach (var IN ITEMS MAJOR MINOR PATCH TWEAK)
    set(${name}_VERSION_${var} ${${var}} PARENT_SCOPE)
    set(PROJECT_VERSION_${var} ${${var}} PARENT_SCOPE)
  endforeach()
endfunction()

# We override project so that we can
# 1) Let a user automatically set a project pre-determined layout as desired
# 2) Override cmake policies in subprojects if they chose to
# 3) Add a "project" scope to properties
# 4) Auto search for C and C++ tools if not already searched for
# 5) Only perform *some* of these steps if we are the root project :)
# 6) Automatically add a few paths to our module path
function (ixm_project_layout name)
  parse(${ARGN} @ARGS=? LAYOUT @ARGS=* LANGUAGES)
  if (Cython IN_LIST LANGUAGES)
    set(IXM_ENABLE_CYTHON ON PARENT_SCOPE)
    list(REMOVE_ITEM LANGUAGES Cython)
  endif()
  if (LANGUAGES)
    list(APPEND REMAINDER LANGUAGES ${LANGUAGES})
  endif()
  upvar(REMAINDER)
  if (LAYOUT)
    set(IXM_CURRENT_LAYOUT_NAME ${LAYOUT} PARENT_SCOPE)
  else()
    unset(IXM_CURRENT_LAYOUT_NAME PARENT_SCOPE)
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
  # TODO: Change this to ${PROJECT_NAME} 🤦
  #dict(ixm::${name}::properties)
  #dict(ixm::${name}::targets)
  #dict(ixm::${name}::fetched)
  dict(INSERT ixm::${name}::properties LAYOUT_FILE ${IXM_CURRENT_LAYOUT_FILE})
  dict(INSERT ixm::${name}::properties LAYOUT_NAME ${IXM_CURRENT_LAYOUT_NAME})
  set(IXM_CURRENT_LAYOUT_FILE ${IXM_CURRENT_LAYOUT_FILE} PARENT_SCOPE)
endfunction()

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
