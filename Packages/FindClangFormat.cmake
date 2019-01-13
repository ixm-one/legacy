import(IXM::Detect::Package)

ixm_find_hints(ClangFormat)

find_program(ClangFormat_EXECUTABLE
  NAMES
    clang-format
    clang-format-9 # lol, future proofing
    clang-format-8
    clang-format-7
    clang-format-6.0
    clang-format-5.0
  HINTS
    ${IXM_FIND_HINTS})

if (ClangFormat_EXECUTABLE)

endif()

#TODO: ClangFormat_VERSION

check_package(ClangFormat
  REQUIRED_VARS ClangFormat_EXECUTABLE
  VERSION_VAR ClangFormat_VERSION)

if (NOT ClangFormat_FOUND)
  return()
endif()

mark_as_advanced(ClangFormat_EXECUTABLE ClangFormat_VERSION)
add_executable(ClangFormat IMPORTED GLOBAL)
add_executable(Clang::Format ALIAS ClangFormat)
add_executable(clang::format ALIAS ClangFormat)
set_target_properties(Clang::Format IMPORTED_LOCATION ${ClangFormat_EXECUTABLE})
