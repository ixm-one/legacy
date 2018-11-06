include_guard(GLOBAL)

include(PushState)
include(IXM)

push_module_path(TargetProperties)
include(CCachePrefix)
include(ClangTidy)
include(GlobSources)
include(Coverage)
include(IPO)
pop_module_path()
