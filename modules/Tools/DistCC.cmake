include_guard(GLOBAL)

include(IXM)

find_package(DistCC)

halt_unless(DistCC FOUND)

set_property(GLOBAL APPEND PROPERTY IXM_COMPILER_LAUNCHERS distcc)
