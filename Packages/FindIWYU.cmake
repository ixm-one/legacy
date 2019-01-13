import(IXM::Detect::Package)

ixm_find_hints(IWYU)
find_program(IWYU_EXECUTABLE
  NAMES
    include-what-you-use
  HINTS ${IXM_FIND_HINTS})

check_package(IWYU
  REQUIRED_VARS IWYU_EXECUTABLE
  VERSION_VAR IWYU_VERSION)

mark_as_advanced(IWYU_EXECUTABLE IWYU_VERSION)
add_executable(IWYU IMPORTED GLOBAL)
add_executable(include-what-you-use ALIAS IWYU)
set_target_properties(include-what-you-use IMPORTED_LOCATION ${IWYU_EXECUTABLE})
