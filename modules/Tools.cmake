include_guard(GLOBAL)

include(PushState)

push_module_path(Tools)
include(ClangCheck)
include(ClangFormat)
include(SCCache)
include(CCache)
include(DistCC)
include(Sphinx)
include(Bloaty)
include(Catch)
pop_module_path()
