include_guard(GLOBAL)

 #TODO: Need to actually make this a unity target lol
function (ixm_target_unity name)
  add_library(${name} OBJECT)
  event(EMIT target:unity ${name})
endfunction()