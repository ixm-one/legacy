include_guard(GLOBAL)

macro(ixm_check_includes)
  foreach (header IN LISTS INCLUDE_HEADERS)
    list(APPEND preamble "#include <${header}>")
  endforeach()
  string(JOIN "\n" IXM_CHECK_PREAMBLE ${preamble})
endmacro()

macro (ixm_check_common)
  ixm_parse(${ARGN}
    @FLAGS QUIET REQUIRED
    @ARGS=?
      EXTRA_CMAKE_FLAGS
      TARGET_TYPE

      INCLUDE_DIRECTORIES
      INCLUDE_HEADERS

      COMPILE_DEFINITIONS
      COMPILE_FEATURES
      COMPILE_OPTIONS

      LINK_DIRECTORIES
      LINK_LIBRARIES
      LINK_OPTIONS)
endmacro()

macro (ixm_check_build_root)
  string(TOLOWER ${variable} output)
  string(REPLACE "_" "-" output ${output})
  set(BUILD_ROOT "${CMAKE_BINARY_DIR}/IXM/CheckEnumExists/${output}")
endmacro()

macro (ixm_check_passed var item)
  if (NOT QUIET)
    message(STATUS "Looking for ${item} - found")
  endif()
  set(${var} ON CACHE INTERNAL ${ARGN})
  file(APPEND ${CMAKE_BINARY_DIR}/${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
    "Determining if '${item}' exists passed with the following output:\n"
    "${${var}_BUILD_OUTPUT}")
endmacro()

macro (ixm_check_failed var item)
  if (NOT QUIET)
    message(STATUS "Looking for ${item} - not found")
  endif()
  set(${var} OFF CACHE INTERNAL ${ARGN})
  file(APPEND ${CMAKE_BINARY_DIR}/${CMAKE_FILES_DIRECTORY}/CMakeError.log
    "Determining if '${item}' exists failed with the following output:\n"
    "${${var}_BUILD_OUTPUT}")
endmacro()

macro (ixm_check_result var item)
  if (${var})
    ixm_check_passed(${var} ${enum} ${ARGN})
  else()
    ixm_check_failed(${var} ${enum} ${ARGN})
  endif()
endmacro()

macro(ixm_check_configure_content content)
  string(CONFIGURE ${content} IXM_CHECK_CONTENT @ONLY)

  configure_file(
    "${IXM_ROOT}/Content/Check/CMakeLists.txt"
    "${BUILD_ROOT}/CMakeLists.txt"
    COPYONLY)
  configure_file(
    "${IXM_ROOT}/Content/Check/main.cxx.in"
    "${BUILD_ROOT}/main.cxx"
    @ONLY)
endmacro()

# Sets all common flags for all check_ functions :)
macro(ixm_check_set_flags var)
  list(APPEND ${var} "-DVERSION=${CMAKE_VERSION}")
  list(APPEND ${var} "${EXTRA_${var}}")
  list(APPEND ${var} "-DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}")

  if (CMAKE_CXX_COMPILER_LAUNCHER)
    list(APPEND ${var} "-DCMAKE_CXX_COMPILER_LAUNCHER=${CMAKE_CXX_COMPILER_LAUNCHER}")
  endif()

  if (INCLUDE_DIRECTORIES)
    list(APPEND ${var} "-DINCLUDE_DIRECTORIES=${INCLUDE_DIRECTORIES}")
  endif()

  if (COMPILE_DEFINITIONS)
    list(APPEND ${var} "-DCOMPILE_DEFINITIONS=${COMPILE_DEFINITIONS}")
  endif()

  if (COMPILE_FEATURES)
    list(APPEND ${var} "-DCOMPILE_FEATURES=${COMPILE_FEATURES}")
  endif()

  if (COMPILE_OPTIONS)
    list(APPEND ${var} "-DCOMPILE_OPTIONS=${COMPILE_OPTIONS}")
  endif()

  if (LINK_DIRECTORIES)
    list(APPEND ${var} "-DLINK_DIRECTORIES=${LINK_DIRECTORIES}")
  endif()

  if (LINK_LIBRARIES)
    list(APPEND ${var} "-DLINK_LIBRARIES=${LINK_LIBRARIES}")
  endif()

  if (LINK_OPTIONS)
    list(APPEND ${var} "-DLINK_OPTIONS=${LINK_OPTIONS}")
  endif()
endmacro()
