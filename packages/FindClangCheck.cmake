include(CheckFindPackage)
include(ImportProgram)
include(PushFindState)
include(Halt)
include(Hide)

push_find_state(ClangCheck)
find_program(ClangCheck_EXECUTABLE NAMES clang-check ${FIND_OPTIONS})
pop_find_state()

check_find_package(ClangCheck EXECUTABLE)
halt_unless(ClangCheck EXECUTABLE)
hide(ClangCheck EXECUTABLE)
import_program(clang::check LOCATION ${ClangCheck_EXECUTABLE} GLOBAL)
