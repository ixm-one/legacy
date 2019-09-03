include_guard(GLOBAL)

function (ixm_target_plugin name)
  add_library(${name} MODULE ${ARGN})
  event(EMIT target:plugin ${name})
endfunction()