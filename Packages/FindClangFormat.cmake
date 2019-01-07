include(PackageSearch)

push_find_state(ClangFormat)
find_program(ClangFormat_EXECUTABLE NAMES clang-format ${FIND_OPTIONS})
pop_find_state()

check_find_package(ClangFormat EXECUTABLE)
halt_unless(ClangFormat EXECUTABLE)
hide(ClangFormat EXECUTABLE)
import_program(clang::format LOCATION ${ClangFormat_EXECUTABLE} GLOBAL)
