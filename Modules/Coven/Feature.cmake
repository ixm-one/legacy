include_guard(GLOBAL)

#[[ For each feature specified during a build, we then present them as
defines for a given project. e.g.,

feature(json "JSON parsing support" HUB{nlohmann/json@v3.5.0:json.hpp})

will turn into

if (${PROJECT_NAME}_STANDALONE)
  option(${PROJECT_NAME}_WITH_JSON "JSON parsing support")
  project_compile_definitions(
    $<$<BOOL:${${PROJECT_NAME}_WITH_JSON}>:COVEN_FEATURE_WITH_JSON)
endif()

Alternatively, if we can place it into a configure header, this would be ideal.

]]

function (ixm_coven_feature name description)
  string(TOUPPER "${PROJECT_NAME}_WITH_${name}" var)
  option(${var} "${description}")
  project_compile_definitions(
    $<$<BOOL:${${var}}>:COVEN_FEATURE_WITH_JSON=1>)
  list(LENGTH ARGN length)
  if (NOT length)
    return()
  endif()
  if (length GREATER 1)
    error("feature(): Only one dependency per feature is permitted")
  endif()
  Fetch(${ARGN})
endfunction()
