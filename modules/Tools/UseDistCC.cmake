include_guard(GLOBAL)
include(TargetCompilerLauncher)

find_package(DistCC)
set_property(GLOBAL APPEND PROPERTY IXM_COMPILER_LAUNCHERS distcc)
