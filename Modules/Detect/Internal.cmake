include_guard(GLOBAL)

macro(ixm_check_includes)
  foreach (header IN LISTS INCLUDE_HEADERS)
    list(APPEND preamble "#include <${header}>")
  endforeach()
  string(JOIN "\n" IXM_CHECK_PREAMBLE ${preamble})
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
