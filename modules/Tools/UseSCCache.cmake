include_guard(GLOBAL)

include(IXM)
find_package(SCCache)

halt_unless(SCCache FOUND)

set_property(GLOBAL APPEND PROPERTY IXM_COMPILER_LAUNCHERS sccache)
