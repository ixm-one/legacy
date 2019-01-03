include_guard(GLOBAL)

import(Properties) # All IXM::Project::Properties related properties
import(Layout) # IXM::Project::Layout support

# We override project so that we can
# 1) Let a user automatically set a project pre-determined layout as desired
# 2) Override cmake policies in subprojects if they chose to
# 3) Add a "project" scope to properties
# 4) Auto search for C and C++ tools if not already searched for
# 5) Only perform *some* of these steps if we are the root project :)
# 6) Automatically add a few paths to our module path
function (project name)
  argparse(${ARGN}
    @ARGS=? LAYOUT)
  # CMAKE_PROJECT_<PROJECT-NAME>_INCLUDE is called here if defined.
  _project(${name} ${REMAINDER})
  if (NOT DEFINED LAYOUT)
    return()
  endif()
  ixm_project_layout_discovery(${LAYOUT})
  get_property(IXM_CURRENT_LAYOUT_FILE GLOBAL PROPERTY IXM_CURRENT_LAYOUT_FILE)
  get_property(IXM_CURRENT_LAYOUT_NAME GLOBAL PROPERTY IXM_CURRENT_LAYOUT_NAME)
  # This is basically how we hack in a custom PROJECT scope for properties.
  # This is also, coincidentally, how _any_ layout can know if it's being
  # includeded via IXM. Just a TARGET named ixm::${PROJECT_NAME}::{lookups}
  # These are also "imported" and not marked as global so they aren't
  # accessible OUTSIDE of te project scope :)
  add_library(ixm::${name}::properties INTERFACE IMPORTED)
  add_library(ixm::${name}::commands INTERFACE IMPORTED)
  add_library(ixm::${name}::targets INTERFACE IMPORTED)
  set_target_properties(ixm::${name}::properties
    PROPERTIES
      INTERFACE_LAYOUT_FILE ${IXM_CURRENT_LAYOUT_FILE}
      INTERFACE_LAYOUT_NAME ${IXM_CURRENT_LAYOUT_NAME})
  include(${IXM_CURRENT_LAYOUT_FILE})

  set(PROJECT_VERSION_MAJOR "${PROJECT_VERSION_MAJOR}" PARENT_SCOPE)
  set(PROJECT_VERSION_MINOR "${PROJECT_VERSION_MINOR}" PARENT_SCOPE)
  set(PROJECT_VERSION_PATCH "${PROJECT_VERSION_PATCH}" PARENT_SCOPE)
  set(PROJECT_VERSION_TWEAK "${PROJECT_VERSION_TWEAK}" PARENT_SCOPE)
  set(PROJECT_VERSION ${PROJECT_VERSION} PARENT_SCOPE)

  set(PROJECT_HOMEPAGE_URL "${PROJECT_HOMEPAGE_URL}" PARENT_SCOPE)
  set(PROJECT_DESCRIPTION "${PROJECT_DESCRIPTION}" PARENT_SCOPE)
  set(PROJECT_SOURCE_DIR "${PROJECT_SOURCE_DIR}" PARENT_SCOPE)
  set(PROJECT_BINARY_DIR "${PROJECT_BINARY_DIR}" PARENT_SCOPE)
  set(PROJECT_NAME "${PROJECT_NAME}" PARENT_SCOPE)

  # TODO: set(<PROJECT-NAME>_vars) :)
endfunction()
