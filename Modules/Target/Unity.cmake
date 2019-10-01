include_guard(GLOBAL)

 #TODO: Need to actually make this a unity target lol
function (ixm_target_unity name)
  add_library(${name} OBJECT)
  event(EMIT target:unity ${name})
#[[
target_sources will be passed a generator expression. Inside of this is:

1) Whether UNITY_BUILD is enabled on the target
2) The path to the UNITY_BUILD_FILE if it is enabled
3) the sources passed to us otherwise.
4) target(UNITY) sources are always private by default.

FIXME: Does this mean target(SOURCES) needs to be taught how unity targets work?

]]
  string(CONCAT sources $<IF:
    $<BOOL:$<TARGET_PROPERTY:${target},UNITY_BUILD>>,
    $<TARGET_PROPERTY:${target},UNITY_BUILD>,
    ${PRIVATE}
  >)
endfunction()
