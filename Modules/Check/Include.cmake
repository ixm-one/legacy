include_guard(GLOBAL)

function (ixm_check_include header)
  ixm_check_common_symbol_prepare(variable ${header})
  get_property(is-found CACHE ${variable} PROPERTY VALUE)
  get_property(arghash CACHE ${variable}_ARGHASH PROPERTY VALUE)

  string(SHA1 current-arghash "${variable} ${header} ${ARGN}")

  if (arghash STREQUAL current-arghash AND is-found)
    return()
  endif()

  set(${variable}_ARGHASH ${current-arghash} CACHE INTERNAL "${variable} hash")
  unset(${variable} CACHE)
  unset(args)

  list(APPEND args INCLUDE_DIRECTORIES)
  list(APPEND args COMPILE_DEFINITIONS)
  list(APPEND args COMPILE_OPTIONS)
  list(APPEND args COMPILE_FEATURES)

  parse(${ARGN}
    @FLAGS QUIET
    @ARGS=? LANGUAGE
    @ARGS=* EXTRA_CMAKE_FLAGS ${args})

  # If no LANGUAGE is given, we assume CXX
  assign(LANGUAGE ? LANGUAGE : CXX)
  string(TOLOWER ${variable} project)
  string(REPLACE "_" "-" project ${project})
  aspect(GET path:check AS directory)
  set(BUILD_ROOT "${directory}/Includes/${project}")

  list(INSERT EXTRA_CMAKE_FLAGS 0
    "CMAKE_${LANGUAGE}_COMPILER:FILEPATH=${CMAKE_${LANGUAGE}_COMPILER}"
    "VERSION:STRING=${CMAKE_VERSION}"
    "LANGUAGE:STRING=${LANGUAGE}"
    "TARGET_TYPE:STRING=OBJECT"
    "NAME:STRING=${project}")
  list(TRANSFORM EXTRA_CMAKE_FLAGS PREPEND "-D" OUTPUT_VARIABLE cmake-flags)

  foreach (arg IN LISTS args ITEMS CMAKE_${LANGUAGE}_COMPILER_LAUNCHER)
    list(APPEND cmake-flags "-D${arg}:STRING=${${arg}}")
  endforeach()

  string(REGEX REPLACE "(.+)" "#include <\\1>" IXM_CHECK_PREAMBLE "${header}")
  
  if (NOT QUIET)
    message(CHECK_START "Looking for include file '${.bold}${header}${.reset}'")
  endif()

  configure_file(
    "${IXM_ROOT}/Templates/Check/CMakeLists.txt"
    "${BUILD_ROOT}/CMakeLists.txt"
    COPYONLY)
  configure_file(
    "${IXM_ROOT}/Templates/Check/main.cxx.in"
    "${BUILD_ROOT}/main.cxx"
    @ONLY)

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

  set(${variable} ${${variable}} CACHE INTERNAL "Have ${header}")
  ixm_cmake_log(${check} "include file '${header}'" "${output}")

  if (NOT QUIET)
    message(CHECK_${check} ${found})
  endif()
endfunction()
