include_guard(GLOBAL)

# XXX: I want to die
function (ixm_check_code name)
  string(MAKE_C_IDENTIFIER "HAVE_${name}" variable)
  list(APPEND flags QUIET)
  list(APPEND single-value LANGUAGE TARGET_TYPE)
  list(APPEND multi-value INCLUDE_DIRECTORIES)
  list(APPEND multi-value COMPILE_DEFINITIONS COMPILE_FEATURES COMPILE_OPTIONS)
  list(APPEND multi-value LINK_DIRECTORIES LINK_LIBRARIES LINK_OPTIONS)
  list(APPEND multi-value WHEN CONTENT EXTRA_CMAKE_FLAGS INCLUDE_HEADERS)

  assign(WHEN ? WHEN : ON)
  if (NOT (${WHEN}))
    return()
  endif()

  get_property(is-found CACHE ${variable} PROPERTY VALUE)
  get_property(arghash CACHE ${variable}_ARGHASH PROPERTY VALUE)

  ixm_check_common_uuid(current-arghash ${name} ${ARGN})

  if (arghash STREQUAL current-arghash AND is-found)
    return()
  endif()

  set(${variable}_ARGHASH ${current-arghash} CACHE INTERNAL "${variable} hash")

  assign(TARGET_TYPE ? TARGET_TYPE : STATIC) # Assume static library if no target type is given
  assign(LANGUAGE ? LANGUAGE : CXX) # XXX: If no language is given CXX MUST be enabled

  string(TOLOWER ${variable} project)
  string(REPLACE "_" project ${project})
  aspect(GET path:check AS directory)
  set(BUILD_ROOT "${directory}/${IXM_CURRENT_CHECK_ACTION}/${project}")
  
  list(PREPEND EXTRA_CMAKE_FLAGS 0
    "CMAKE_${LANGUAGE}_COMPILER:FILEPATH=${CMAKE_${LANGUAGE}_COMPILER}"
    "TARGET_TYPE:STRING=${TARGET_TYPE}"
    "VERSION:STRING=${CMAKE_VERSION}"
    "LANGUAGE:STRING=${LANGUAGE}"
    "NAME:STRING=${project}")

  list(TRANSFORM EXTRA_CMAKE_FLAGS PREPEND "-D" OUTPUT_VARIABLE cmake-flags)
  foreach (arg IN LISTS args ITEMS CMAKE_${LANGUAGE}_COMPILER_LAUNCHER)
    if (DEFINED ${arg})
      list(APPEND cmake-flags "-D${arg}:STRING=${${arg}}")
    endif()
  endforeach()

  if (NOT QUIET)
    string(TOLOWER "${action}" type)
    message(CHECK_START "Looking for (${type}) ${.bold}${name}${.reset}")
  endif()

  set(result "${.lime}success${.reset}")
  set(check PASS)

  if (NOT ${variable})
    set(found "${.crimson}failed${.reset}")
    set(check FAIL)
  endif()

  if (NOT QUIET)
    message(CHECK_${check} "${result}")
  endif()

endfunction()
