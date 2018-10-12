include_guard(GLOBAL)
include(TargetCompilerLauncher)

find_package(CCache REQUIRED)
set_property(GLOBAL APPEND PROPERTY IXM_COMPILER_LAUNCHERS ccache)

# TODO: define_property for each CCache configuration setting
#       this will allow us to also use DistCC *and* IceCream on targets
#       in addition to ccache
