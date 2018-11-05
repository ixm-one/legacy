include_guard(GLOBAL)

include(IXM)

find_package(ClangCheck)
halt_unless(ClangCheck FOUND)
