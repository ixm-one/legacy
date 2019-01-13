import(IXM::Detect::Package)

ixm_find_hints(ClangTidy)
find_program(ClangTidy_EXECUTABLE
  NAMES
    clang-tidy
    clang-tidy-9
    clang-tidy-8
    clang-tidy-7
    clang-tidy-6.0
    clang-tidy-5.0
  HINTS
    ${IXM_FIND_HINTS})

if (ClangTidy_EXECUTABLE)
endif()

mark_as_advanced(ClangTidy_EXECUTABLE ClangTidy_VERSION)
add_executable(ClangTidy IMPORTED GLOBAL)
add_executable(clang::tidy ALIAS ClangTidy)
add_executable(Clang::Tidy ALIAS ClangTidy)
set_target_properties(ClangTidy
  PROPERTIES IMPORTED_LOCATION ${ClangTidy_EXECUTABLE})

