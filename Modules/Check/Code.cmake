include_guard(GLOBAL)

function (ixm_check_code name)
  list(APPEND flags QUIET)
  list(APPEND single-value LANGUAGE TARGET_TYPE OUTPUT_VARIABLE)
  list(APPEND multi-value WHEN CONTENT EXTRA_CMAKE_FLAGS INCLUDE_HEADERS)
  list(APPEND targets INCLUDE_DIRECTORIES)
  list(APPEND targets COMPILE_DEFINITIONS COMPILE_FEATURES COMPILE_OPTIONS)
  list(APPEND targets LINK_DIRECTORIES LINK_LIBRARIES LINK_OPTIONS)

  cmake_parse_arguments(ARG
    "${flags}"
    "${single-value}"
    "${multi-value};${targets}"
    ${ARGN})

  ixm_check_common_prepare(variable ${name})

  assign(variable ? ARG_OUTPUT_VARIABLE : ${variable})
  assign(target-type ? ARG_TARGET_TYPE : "STATIC")
  assign(language ? ARG_LANGUAGE : "CXX")
  assign(when ? ARG_WHEN : ON)

  if (NOT (${when}))
    return()
  endif()

  ixm_check_common_hash(is-up-to-date ${name} ${ARGN})
  if (is-up-to-date)
    return()
  endif()

  string(TOLOWER ${variable} project)
  string(REPLACE "_" "-" project ${project})

  aspect(GET path:check AS directory)
  set(build-root "${directory}/${project}")
  list(INSERT ARG_EXTRA_CMAKE_FLAGS 0
    "CMAKE_${language}_COMPILER:FILEPATH=${CMAKE_${language}_COMPILER}"
    "TARGET_TYPE:STRING=${target-type}"
    "VERSION:STRING=${CMAKE_VERSION}"
    "LANGUAGE:STRING=${language}"
    "NAME:STRING=${project}")
  list(TRANSFORM ARG_EXTRA_CMAKE_FLAGS PREPEND "-D" OUTPUT_VARIABLE cmake-flags)
  foreach (arg IN LISTS targets)
    if (DEFINED ARG_${arg})
      list(APPEND cmake-flags "-D${arg}:STRING=${ARG_${arg}}")
    endif()
  endforeach()

  if (ARG_INCLUDE_HEADERS)
    list(APPEND args INCLUDE_DIRECTORIES COMPILE_DEFINITIONS COMPILE_OPTIONS COMPILE_FEATURES)
    foreach (arg IN LISTS args)
      if (DEFINED ARG_${arg})
        list(APPEND flags ${arg} ${ARG_${arg}})
      endif()
    endforeach()
    list(APPEND flags LANGUAGE ${language})
    foreach (header IN LISTS ARG_INCLUDE_HEADERS)
      ixm_check_common_prepare(header-variable ${header})
      string(PREPEND CMAKE_MESSAGE_INDENT "  ")
      check(INCLUDE ${header} ${flags})
      if (NOT ${header-variable})
        return()
      endif()
    endforeach()
  endif()

  list(TRANSFORM INCLUDE_HEADERS REPLACE "(.+)" "#include <\\1>")
  list(JOIN INCLUDE_HEADERS "\n" IXM_CHECK_PREAMBLE)
  string(CONFIGURE "${CONTENT}" IXM_CHECK_CONTENT @ONLY)

  set(check-root "${IXM_ROOT}/Templates/Check")

  configure_file("${check-root}/CMakeLists.txt" "${build-root}/CMakeLists.txt" COPYONLY)
  # FIXME: Does not take other languages into account :/
  configure_file("${check-root}/main.cxx.in" "${build-root}/main.cxx" @ONLY)

  if (NOT ARG_QUIET)
    message(CHECK_START "Looking for ${.bold}${name}${.reset}")
  endif()

  try_compile(${variable}
    "${build-root}/build"
    "${build-root}"
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

  if (NOT ARG_QUIET)
    message(CHECK_${check} "${found}")
  endif()

  if (NOT ${variable})
    file(REMOVE_RECURSE "${build-root}/build")
  endif ()
endfunction()
