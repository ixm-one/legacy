include_guard(GLOBAL)

function (ixm_check_common_symbol_prepare out name)
  string(TOUPPER "${name}" item)
  string(REPLACE "::" ":" item "${item}")
  string(MAKE_C_IDENTIFIER "HAVE_${item}" variable)
  set(${out} ${variable} PARENT_SCOPE)
endfunction()

function (ixm_check_common_symbol variable name)
  get_property(is-found CACHE ${variable} PROPERTY VALUE)
  get_property(arghash CACHE ${variable}_ARGHASH PROPERTY VALUE)

  # TODO: Change to generate a UUID with the subcommand as the namespace.
  string(SHA1 current-arghash "${variable} ${name} ${ARGN}")

  if (arghash STREQUAL current-arghash AND is-found)
    return()
  endif()

  set(${variable}_ARGHASH ${current-arghash} CACHE INTERNAL "${variable} hash")
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
    @ARGS=? LANGUAGE TARGET_TYPE
    @ARGS=* CONTENT EXTRA_CMAKE_FLAGS INCLUDE_HEADERS ${args})

  # If no LANGUAGE is given, we assume CXX
  assign(TARGET_TYPE ? TARGET_TYPE : STATIC)
  assign(LANGUAGE ? LANGUAGE : CXX)

  string(TOLOWER ${variable} project)
  string(REPLACE "_" "-" project ${project})
  attribute(GET directory NAME path:check DOMAIN ixm)
  set(BUILD_ROOT "${directory}/Symbols/${project}")

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
      ixm_check_common_symbol_prepare(variable ${header})
      check(INCLUDE ${header} ${flags} LANGUAGE ${LANGUAGE})
      if (NOT ${variable})
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
    log(INFO "Looking for (${action}) ${name}")
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

  if (NOT ${variable})
    file(REMOVE_RECURSE "${BUILD_ROOT}/build")
  endif()

  set(result "Looking for ${name} - ${found}")
  if (NOT ${variable} AND REQUIRED)
    log(FATAL "${result}")
  elseif(NOT QUIET AND ${variable})
    success("${result}")
  elseif(NOT QUIET)
    failure("${result}")
  endif()
endfunction()
