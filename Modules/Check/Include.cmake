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

  parse(${ARGN}
    @FLAGS QUIET REQUIRED
    @ARGS=? LANGUAGE
    @ARGS=* EXTRA_CMAKE_FLAGS ${args})

  # If no LANGUAGE is given, we assume CXX
  var(LANGUAGE LANGUAGE CXX)
  string(TOLOWER ${variable} project)
  string(REPLACE "_" "-" project ${project})
  set(BUILD_ROOT "${CMAKE_BINARY_DIR}/IXM/Check/Includes/${project}")

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
  
  configure_file(
    "${IXM_ROOT}/Templates/Check/CMakeLists.txt"
    "${BUILD_ROOT}/CMakeLists.txt"
    COPYONLY)
  configure_file(
    "${IXM_ROOT}/Templates/Check/main.cxx.in"
    "${BUILD_ROOT}/main.cxx"
    @ONLY)

  if (NOT QUIET)
    info("Looking for include file ${header}")
  endif()

  try_compile(${variable}
    "${BUILD_ROOT}/build"
    "${BUILD_ROOT}"
    "${project}"
    CMAKE_FLAGS ${cmake-flags}
    OUTPUT_VARIABLE output)

  set(logfile "CMakeOutput.log")
  set(status "passed")
  set(found "found")

  if (NOT ${variable})
    set(logfile "CMakeError.log")
    set(status "failed")
    set(found "not found")
  endif()

  set(${variable} ${${variable}} CACHE INTERNAL "Have ${header}")
  file(APPEND "${CMAKE_BINARY_DIR}/${CMAKE_FILES_DIRECTORY}/${logfile}"
    "Determining if include file '${header}' exists ${status} with the following output:\n"
    "${output}")

  set(result "Looking for include file ${header} - ${found}")
  if (REQUIRED AND NOT ${variable})
    error("${result}")
  elseif(NOT QUIET AND ${variable})
    info("${result}")
  endif()
endfunction()
