import(IXM::Detect::Package)

ixm_find_hints(ClangCheck)
find_program(ClangCheck_EXECUTABLE
  NAMES
    clang-check
    clang-check-9
    clang-check-8
    clang-check-7
    clang-check-6.0
    clang-check-5.0
  HINTS
    ${IXM_FIND_HINTS})

check_package(ClangCheck
  REQUIRED_VARS ClangCheck_EXECUTABLE
  VERSION_VAR ClangCheck_VERSION)

mark_as_advanced(ClangCheck_EXECUTABLE ClangCheck_VERSION)
add_executable(ClangCheck IMPORTED GLOBAL)
add_executable(Clang::Check ALIAS ClangCheck)
add_executable(clang::check ALIAS ClangCheck)
set_target_properties(Clang::Check IMPORTED_LOCATIONS ${ClangCheck_EXECUTABLE})
