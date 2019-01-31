include_guard(GLOBAL)

function (ixm_check_common_symbol variable name)
  get_property(is-found CACHE ${variable} PROPERTY VALUE)
  if (is-found)
    return()
  endif()
  unset(${variable} CACHE)

  list(APPEND args INCLUDE_DIRECTORIES)
  list(APPEND args COMPILE_DEFINITIONS)
  list(APPEND args COMPILE_FEATURES)
  list(APPEND args COMPILE_OPTIONS)
  list(APPEND args LINK_DIRECTORIES)
  list(APPEND args LINK_LIBRARIES)
  list(APPEND args LINK_OPTIONS)

  parse(${ARGN}
    @FLAGS QUIET REQUIRED
    @ARGS=? LANGUAGE
    @ARGS=* CONTENT EXTRA_CMAKE_FLAGS TARGET_TYPE INCLUDE_HEADERS ${args})

  # If no LANGUAGE is given, we assume CXX
  var(LANGUAGE LANGUAGE CXX)

  string(TOLOWER ${variable} project)
  string(REPLACE "_" "-" project ${project})
  set(BUILD_ROOT "${CMAKE_BINARY_DIR}/IXM/Check/Symbols/${project}")

  list(INSERT EXTRA_CMAKE_FLAGS 0
    "CMAKE_${LANGUAGE}_COMPILER:FILEPATH=${CMAKE_${LANGUAGE}_COMPILER}"
    "VERSION:STRING=${CMAKE_VERSION}"
    "LANGUAGE:STRING=${LANGUAGE}"
    "NAME:STRING=${project}")

  list(TRANSFORM EXTRA_CMAKE_FLAGS PREPEND "-D")
  list(APPEND cmake-flags ${EXTRA_CMAKE_FLAGS})

  foreach (arg IN LISTS args ITEMS CMAKE_${LANGUAGE}_COMPILER_LAUNCHER)
    if (DEFINED ${arg})
      list(APPEND cmake-flags "-D${arg}:STRING=${${arg}}")
    endif()
  endforeach()

  # Configure content for headers
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
    info("Looking for ${name}")
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

  set(${variable} ${${variable}} CACHE INTERNAL "Have ${name}")
  file(APPEND "${CMAKE_BINARY_DIR}/${CMAKE_FILES_DIRECTORY}/${logfile}"
    "Determining if '${name}' exists ${status} with the following output:\n"
    "${output}")

  set(result "Looking for ${name} - ${found}")
  if (REQUIRED AND NOT ${variable})
    error("${result}")
  elseif(NOT QUIET AND ${variable})
    info("${result}")
  endif()


endfunction()
