include(PackageSearch)
include(IXM)

find_program(ClangCheck_EXECUTABLE NAMES clang-check ${FIND_OPTIONS})
check_find_package(ClangCheck EXECUTABLE)
halt_unless(ClangCheck EXECUTABLE)
hide(ClangCheck EXECUTABLE)
import_program(clang::check LOCATION ${ClangCheck_EXECUTABLE} GLOBAL)
