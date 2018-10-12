include(FindPackageHandleStandardArgs)
include(ImportProgram)
include(PushFindState)
include(Breakout)
include(Hide)

push_find_state(ClangTidy)
find_program(ClangTidy_EXECUTABLE NAMES clang-tidy ${FIND_OPTIONS})
pop_find_state()

find_package_handle_standard_args(ClangTidy
  REQUIRED_VARS ClangTidy_EXECUTABLE)

breakout(ClangTidy_EXECUTABLE)
import_program(clang::tidy LOCATION ${ClangTidy_EXECUTABLE} GLOBAL)
hide(ClangTidy EXECUTABLE)
