include_guard(GLOBAL)

# DNS UUID 6ba7b810-9dad-11d1-80b4-00c04fd430c8

function (ixm_check_common_symbol_prepare out name)
  string(TOUPPER "${name}" item)
  string(REPLACE "::" ":" item "${item}")
  string(MAKE_C_IDENTIFIER "HAVE_${item}" variable)
  set(${out} ${variable} PARENT_SCOPE)
endfunction()

function (ixm_check_common_uuid output name)
  get_property(blueprint DIRECTORY PROPERTY ixm::blueprint::name)
  assign(blueprint ? blueprint : "cmake")
  string(TOLOWER "${blueprint}" blueprint)
  set(uri "one.ixm.${blueprint}/${PROJECT_NAME}/check/${name}/${ARGN}")
  string(UUID uuid
    NAMESPACE 6ba7b810-9dad-11d1-80b4-00c04fd430c8
    NAME "${uri}"
    TYPE SHA1)
  set(${output} ${uuid} PARENT_SCOPE)
endfunction()

# TODO: This entire thing needs a *massive* overhaul. It's very tricky, and
# could with a little work, be cleaned up and made more generic. It would
# require breaking it up into multiple arguments however
function (ixm_check_common_symbol variable name)
  # TODO: every option we depend on needs to be set to 'option=<value>'
  # and then joined via &. This way we can represent the entire parameter list as a URI
  # Is this a good idea? No. But this is CMake. There are no good ideas
  # Additionally, setting *all* of these into a dictionary, then hashing the
  # file would allow us to do a quicker check without the UUID bullshit.
  # TODO: All options *must* be voided for safety reasons because "~*~CMAKE~*~ UwU"
  list(APPEND args INCLUDE_DIRECTORIES)
  list(APPEND args COMPILE_DEFINITIONS)
  list(APPEND args COMPILE_FEATURES)
  list(APPEND args COMPILE_OPTIONS)
  list(APPEND args LINK_DIRECTORIES)
  list(APPEND args LINK_LIBRARIES)
  list(APPEND args LINK_OPTIONS)

  parse(${ARGN}
    @FLAGS QUIET
    @ARGS=? LANGUAGE TARGET_TYPE
    @ARGS=* CONTENT EXTRA_CMAKE_FLAGS INCLUDE_HEADERS WHEN ${args})

  assign(WHEN ? WHEN : ON)
  if (NOT (${WHEN}))
    return()
  endif()

  get_property(is-found CACHE ${variable} PROPERTY VALUE)
  get_property(arghash CACHE ${variable}_ARGHASH PROPERTY VALUE)

  # TODO: Update this to pull from the ixm::blueprint::name property?
  get_property(IXM_CURRENT_BLUEPRINT_NAME DIRECTORY PROPERTY ixm::blueprint::name)
  assign(blueprint ? IXM_CURRENT_BLUEPRINT_NAME : "cmake")
  string(TOLOWER "${blueprint}." blueprint)
  set(uri "one.ixm.${blueprint}/${PROJECT_NAME}/check/${name}/${ARGN}")
  string(UUID current-arghash
    NAMESPACE 6ba7b810-9dad-11d1-80b4-00c04fd430c8
    NAME "${uri}"
    TYPE SHA1)

  if (arghash STREQUAL current-arghash AND is-found)
    return()
  endif()

  set(${variable}_ARGHASH ${current-arghash} CACHE INTERNAL "${variable} hash")
  unset(${variable} CACHE)

  # If no LANGUAGE is given, we assume CXX
  assign(TARGET_TYPE ? TARGET_TYPE : STATIC)
  assign(LANGUAGE ? LANGUAGE : CXX)

  string(TOLOWER ${variable} project)
  string(REPLACE "_" "-" project ${project})
  aspect(GET path:check AS directory)
  set(BUILD_ROOT "${directory}/${IXM_CURRENT_CHECK_ACTION}/${project}")

  list(INSERT EXTRA_CMAKE_FLAGS 0
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

  # Configure content for headers
  if (INCLUDE_HEADERS)
    foreach (arg IN ITEMS INCLUDE_DIRECTORIES COMPILE_DEFINITIONS COMPILE_OPTIONS)
      if (DEFINED ${arg})
        list(APPEND flags ${arg} ${${arg}})
      endif()
    endforeach()
    foreach (header IN LISTS INCLUDE_HEADERS)
      ixm_check_common_symbol_prepare(header-variable ${header})
      set(CMAKE_MESSAGE_INDENT "  ${CMAKE_MESSAGE_INDENT}")
      check(INCLUDE ${header} ${flags} LANGUAGE ${LANGUAGE})
      if (NOT ${header-variable})
        return()
      endif()
    endforeach()
  endif()


  list(TRANSFORM INCLUDE_HEADERS REPLACE "(.+)" "#include <\\1>")
  list(JOIN INCLUDE_HEADERS "\n" IXM_CHECK_PREAMBLE)
  string(CONFIGURE "${CONTENT}" IXM_CHECK_CONTENT @ONLY)

  configure_file(
    "${IXM_ROOT}/Templates/Check/CMakeLists.txt"
    "${BUILD_ROOT}/CMakeLists.txt"
    COPYONLY)
  configure_file(
    "${IXM_ROOT}/Templates/Check/main.cxx.in"
    "${BUILD_ROOT}/main.cxx"
    @ONLY)

  if (NOT QUIET)
    string(TOLOWER "${action}" type)
    message(CHECK_START "Looking for (${type}) ${.bold}${name}${.reset}")
  endif()

  try_compile(${variable}
    "${BUILD_ROOT}/build"
    "${BUILD_ROOT}"
    "${project}"
    CMAKE_FLAGS ${cmake-flags}
    OUTPUT_VARIABLE output)

  set(found "${.lime}found${.reset}")
  set(check PASS)

  if (NOT ${variable})
    set(found "${.crimson}not found${.reset}")
    set(check FAIL)
  endif()

  set(${variable} ${${variable}} CACHE INTERNAL "Have ${name}")
  ixm_cmake_log(${check} ${name} ${output})

  if (NOT QUIET)
    message(CHECK_${check} "${found}")
  endif()

  if (NOT ${variable})
    file(REMOVE_RECURSE "${BUILD_ROOT}/build")
  endif()

endfunction()
