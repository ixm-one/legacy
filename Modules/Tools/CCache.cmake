include_guard(GLOBAL)

include(IXM)

find_package(CCache)

halt_unless(CCache FOUND)

set_property(GLOBAL APPEND PROPERTY IXM_COMPILER_LAUNCHERS ccache)

# TODO: define_property for each CCache configuration setting
#       this will allow us to also use DistCC *and* IceCream on targets
#       in addition to ccache
