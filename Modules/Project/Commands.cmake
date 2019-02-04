include_guard(GLOBAL)

# We override project so that we can
# 1) Let a user automatically set a project pre-determined layout as desired
# 2) Override cmake policies in subprojects if they chose to
# 3) Add a "project" scope to properties
# 4) Auto search for C and C++ tools if not already searched for
# 5) Only perform *some* of these steps if we are the root project :)
# 6) Automatically add a few paths to our module path
function (ixm_project_layout name)
  parse(${ARGN} @ARGS=? LAYOUT @ARGS=* LANGUAGES)
  upvar(REMAINDER)
  if (LAYOUT)
    set(IXM_CURRENT_LAYOUT_NAME ${LAYOUT} PARENT_SCOPE)
  else()
    unset(IXM_CURRENT_LAYOUT_NAME PARENT_SCOPE)
  endif()
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
