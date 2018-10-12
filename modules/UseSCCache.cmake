include_guard(GLOBAL)
include(TargetCompilerLauncher)

find_package(SCCache REQUIRED)
set_property(GLOBAL APPEND PROPERTY IXM_COMPILER_LAUNCHERS sccache)
