include_guard(GLOBAL)

#[[ This replaces our target_sources override ]]
#[[ As a result, we have a bit more say in things, *and* events can received
from multiple operations, instead of us dynamically calling `target_sources_<ext>`.
This means we can have something like target://sources/<ext> and then execute
each one in a list. :D
]]

function (ixm_target_sources)
endfunction()