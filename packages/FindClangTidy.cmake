include(CheckFindPackage)
include(ImportProgram)
include(PushFindState)
include(Halt)
include(Hide)

push_find_state(ClangTidy)
find_program(ClangTidy_EXECUTABLE NAMES clang-tidy ${FIND_OPTIONS})
pop_find_state()

check_find_package(ClangTidy EXECUTABLE)
halt_unless(ClangTidy EXECUTABLE)
hide(ClangTidy EXECUTABLE)
import_program(clang::tidy LOCATION ${ClangTidy_EXECUTABLE} GLOBAL)
