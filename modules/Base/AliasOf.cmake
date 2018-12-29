include_guard(GLOBAL)

#[[
Given a target name, set the variable to its aliased target, or to just target
]]
function(alias_of target var)
  set(${var} ${target} PARENT_SCOPE)
  get_target_property(actual ${target} ALIASED_TARGET)
  if (actual)
    set(${var} ${actual} PARENT_SCOPE)
  endif()
endfunction()
