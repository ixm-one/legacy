include_guard(GLOBAL)

include(IXM)
find_package(Bloaty)

halt_unless(Bloaty FOUND)
